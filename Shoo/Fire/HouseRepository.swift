//
//  HouseRepository.swift
//  Shoo
//
//  Created by Benjamin Schiff on 6/6/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase
import Combine

class HouseRepository {
    private var hListener: ListenerRegistration?
    private var mListener: ListenerRegistration?
    private var pListener: ListenerRegistration?
    private var houseDB = Firestore.firestore().collection("Homes")
    private var mateDB = Firestore.firestore().collection("profiles")
    
    func startListener(Fid: String, userID: String, result: @escaping (Result<[Mate], Error>) -> Void) {
        stopListener()
        var mateIDs: [String] = []
        var fid = Fid
        DispatchQueue.main.async {
            if fid == "" {
                fid = self.createHouse(uid: userID)
                self.mateDB.document(userID).setData([ "house": fid ], merge: true)
            }
            self.hListener = self.houseDB
                .document(fid)
                .addSnapshotListener { (snapshot, error) in
                    if let error = error {
                        result(.failure(error))
                        return
                    }
                    
                    guard let documents = snapshot else {
                        result(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Snapshot is empty"])))
                        return
                    }
                    //dump(documents.data())
                    mateIDs = documents.get("mates") as? [String] ?? []
                    
                    if(mateIDs.count > 1){
                        mateIDs.removeAll(where: { $0 == userID })
                        self.mListener = self.mateDB
                            .whereField("uid", in: mateIDs)
                            .addSnapshotListener { (snapshot, error) in
                                if let error = error {
                                    result(.failure(error))
                                    return
                                }
                                
                                guard let documents = snapshot?.documents else {
                                    result(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Snapshot is empty"])))
                                    return
                                }
                                
                                let mates = documents.map { Mate(document: $0) }
                                let oMates = mates.sorted { $0.name.lowercased() < $1.name.lowercased() }
                                result(.success(oMates))
                        }
                    }
            }
        }
    }
    
    
    func createHouse(uid: String) -> String{
        //xvar houseID = UserDefaults.standard.string(forKey: "houseId") ?? ""
        //create a new house and add myself
        var ref: DocumentReference? = nil
        ref = houseDB.addDocument(data: [
            "name": "Home",
            "mates": [uid]
        ]){ err in
            if let err = err {
                print("Error creating house: \(err)")
            } else {
                print("House create with ID: \(ref!.documentID)")
            }
        }
        dump(ref?.documentID)
        //db.collection("profiles").document(uid).setValue(houseID, forKey: "house")
        return ref?.documentID ?? ""
    }
    
    func checkHouseExists( _ houseId: String, completion: @escaping (Result<Bool, CheckError>) -> Void) {
        print(".5")
        //semaphore.wait()
        let docRef = houseDB.document(houseId)
        docRef.getDocument { (document, error) in
            //semaphore.signal()
            completion(.success(true))
            print("1")
        }
        //semaphore.signal()
        completion(.failure(.couldNotFindDocument))
    }
    
    func addMate(_ mate: Mate) {
        mateDB.document(mate.id).setData(mate.toJSONSnapshot)
    }
    
    func updateHouse(_ prof: Profile, _ oldID: String){
        mateDB.document(prof.uid).updateData(["house": prof.house])
        houseDB.document(oldID).updateData(["mates": FieldValue.arrayRemove([prof.uid])])
        houseDB.document(prof.house).updateData(["mates": FieldValue.arrayUnion([prof.uid])])
        houseDB.document(oldID).getDocument { (document, error) in
            let numMates = document?.get("mates") as? [String] ?? []
            if numMates.count == 0 {
                self.houseDB.document(oldID).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
            }
        }
    }
    
    func updateMate(_ mate: Mate) {
        mateDB.document(mate.id).updateData(mate.toJSONSnapshot)
    }
    
    func removeMate(_ mate: Mate) {
        mateDB.document(mate.id).delete()
    }
    
    func stopListener() {
        hListener?.remove()
        hListener = nil
        mListener?.remove()
        mListener = nil
    }
    
    deinit {
        stopListener()
    }
    
    func qUpdateStatus(_ status: Status, _ profile: Profile){
        
        if(status != profile.status ||
            profile.end != Date().timeIntervalSince1970 + 360*60) {
            var prof = profile
            prof.end = Date().timeIntervalSince1970 + 360*60
            prof.start = Date().timeIntervalSince1970
            switch status {
            case .red:
                prof.status = .red
                prof.reason = ""
            case .yellow:
                prof.status = .yellow
                prof.reason = ""
            default:
                prof.status = .green
                prof.reason = ""
            }
            mateDB.document(prof.uid).updateData(["reason": prof.reason,"status": prof.status.rawValue, "end": prof.end, "start": prof.start])
        }
    }
    
    func qUpdateTime(_ profile: Profile, _ timeSelection: Int){
        var x = 0
        switch timeSelection{
        case 0:
            x = 60 * 10
        case 1:
            x = 60 * 15
        case 2:
            x = 60 * 20
        case 3:
            x = 60 * 30
        case 4:
            x = 60 * 45
        case 5:
            x = 60 * 60
        case 6:
            x = 60 * 120
        case 7:
            x = 60 * 180
        case 8:
            x = 60 * 240
        case 9:
            x = 60 * 60 * 6
        case 10:
            x = Int(Date.distantFuture.timeIntervalSince1970)
        default:
            x = 60 * 60 * 4
        }
        var prof = profile
        prof.end = Double(x) + Date().timeIntervalSince1970 + 60
        mateDB.document(prof.uid).updateData(["end": prof.end])
    }
    
    /*
     func qUpdateTime(_ state: Double, _ profile: Profile){
     var prof = profile
     prof.end = profile.end + (10 * 60 * state)
     mateDB.document(prof.uid).updateData(["end": prof.end])
     }*/
    
    func saveState(user: Profile, status: Status, reason: String, end: Double) {
        if (user.status != status || user.reason != reason || user.end != end){
            var endV = end
            if endV < Date().timeIntervalSince1970 {
                endV = (Date().timeIntervalSince1970 + 4*60*60)
            }
            mateDB.document(user.uid).updateData(["reason": reason,"status": status.rawValue, "end": endV, "start": Date().timeIntervalSince1970])
        }
    }
    
    func noStatus(id: String){
        mateDB.document(id).updateData(["reason": "", "status": 0])
    }
}
