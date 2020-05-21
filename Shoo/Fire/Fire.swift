//
//  Fire.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/17/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Firebase
import Combine


enum FireAuthState {
    case undefined, signedOut, signedIn
}

class HouseRepository {
    private var hListener: ListenerRegistration?
    private var mListener: ListenerRegistration?
    private var houseDB = Firestore.firestore().collection("Homes")
    private var mateDB = Firestore.firestore().collection("profiles")
    
    func startListener(Fid: String, userID: String, result: @escaping (Result<[Mate], Error>) -> Void) {
        stopListener()
        var mateIDs: [String] = []
        var fid = Fid
        if fid == "" {
            fid = createHouse(uid: userID)
        }
        hListener = houseDB
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
                dump(documents.data())
                let houses = documents.get("mates") as? [String] ?? []
                mateIDs = houses
                
                if(mateIDs != []){
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
                            result(.success(mates))
                    }
                }
        }
    }
    
    func createHouse(uid: String) -> String{
        //xvar houseID = UserDefaults.standard.string(forKey: "houseId") ?? ""
        //create a new house and add myself
        var ref: DocumentReference? = nil
        ref = houseDB.addDocument(data: [
            "name": "house",
            "Mates": [uid]
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        dump(ref?.documentID)
        //db.collection("profiles").document(uid).setValue(houseID, forKey: "house")
        return ref?.documentID ?? ""
    }
    
    func checkHouseExists(_ houseId: String) -> Bool{
        let docRef = houseDB.document(houseId)
        var out = false
        docRef.getDocument { (document, error) in
            if let document = document {
                out = document.exists
            }
            
        }
        return out
    }
    
    func addMate(_ mate: Mate) {
        mateDB.document(mate.id).setData(mate.toJSONSnapshot)
    }
    
    func updateHouse(_ prof: Profile, _ oldID: String){
        mateDB.document(prof.uid).updateData(["house": prof.house])
        houseDB.document(prof.house).updateData(["mates": FieldValue.arrayUnion([prof.uid])])
        houseDB.document(oldID).updateData(["mates": FieldValue.arrayRemove([prof.uid])])
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
    
    func qUpdateStatus(_ statusInt: Int, _ profile: Profile){
        var prof = profile
        prof.end = Date().addingTimeInterval(86400)
        prof.start = Date()
        switch statusInt {
        case 1:
            prof.status = 1
            prof.reason = "Quiet"
        case 2:
            prof.status = 2
            prof.reason = "Shoo"
        default:
            prof.status = 0
            prof.reason = "Free"
        }
        mateDB.document(prof.uid).updateData(["reason": prof.reason,"status": prof.status, "end": prof.end, "start": prof.start])
    }
    
    
}
class Fire: ObservableObject {
    
    @Published var isUserAuthenticated: FireAuthState = .undefined
    @Published var profile: Profile = Profile(uid: "", name: "", reason: "", status: 0, end: Date(), start: Date(), house: "")
    //@Published var houseID: String = UserDefaults.standard.string(forKey: "houseId") ?? ""
    
    
    var mateList: [String] = []
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    let db = Firestore.firestore()
    
    // MARK: - Auth
    
    func configureFirebaseStateDidChange() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            guard let user = user else {
                print("User is signed out")
                self.isUserAuthenticated = .signedOut
                return
            }
            
            print("Successfully authenticated user with uid: \(user.uid)")
            FireFirestore.retreiveProfile(uid: user.uid) { (result) in
                switch result {
                case .success(let profile):
                    print("Retreived: \(profile)")
                    self.profile = profile
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
            self.isUserAuthenticated = .signedIn
        })
    }
    
    @Published var mates: [Mate] = []
    @Published var error: Error? = nil
    var repository = HouseRepository()
    
    func startListener() {
        self.error = nil
        dump(self.profile)
        repository.startListener(Fid: self.profile.house, userID: self.profile.uid, result: {[weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let items):
                self.mates = items
                
            case .failure(let error):
                self.error = error
            }
        } )
    }
    
    func quickUpdateStatus(statInt: Int, profile: Profile) {
        repository.qUpdateStatus(statInt, profile)
    }
    
    func addMate(_ mate: Mate) {
        repository.addMate(mate)
    }
    
    func updateMate(_ mate: Mate) {
        let _mate = mate
        repository.updateMate(_mate)
    }
    
    func removeMate(_ mate: Mate) {
        repository.removeMate(mate)
    }
    
    func updateHouse(_ prof: Profile, _ oldID: String){
        repository.updateHouse(prof, oldID)
        self.startListener()
    }
    
    func stopListener() {
        repository.stopListener()
    }
    
    func signOut(){
        self.isUserAuthenticated = .signedOut
    }
    
    func testHouse(_ houseId: String) -> Bool{
        return repository.checkHouseExists(houseId)
    }
    
    
}
