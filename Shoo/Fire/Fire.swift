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

enum CheckError: Error {
    case couldNotFindDocument
}

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
    
    func qUpdateStatus(_ statusInt: Int, _ profile: Profile){
        
        if(statusInt != profile.status ||
            profile.end != Calendar.current.nextDate(after: Date(), matching: DateComponents(hour: 0, minute: 0), matchingPolicy: .nextTimePreservingSmallerComponents)!.timeIntervalSince1970) {
            var prof = profile
            prof.end = Calendar.current.nextDate(after: Date(), matching: DateComponents(hour: 0, minute: 0), matchingPolicy: .nextTimePreservingSmallerComponents)!.timeIntervalSince1970
            prof.start = Date().timeIntervalSince1970
            switch statusInt {
            case 1:
                prof.status = 1
                prof.reason = ""
            case 2:
                prof.status = 2
                prof.reason = ""
            case 0:
                prof.status = 0
                prof.reason = ""
            default:
                prof.status = -1
                prof.reason = ""
            }
            mateDB.document(prof.uid).updateData(["reason": prof.reason,"status": prof.status, "end": prof.end, "start": prof.start])
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
            x = Int(Calendar.current.nextDate(after: Date(), matching: DateComponents(hour: 0, minute: 0), matchingPolicy: .nextTimePreservingSmallerComponents)!.timeIntervalSince1970 - Date().timeIntervalSince1970)//until midnight
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
    
    func saveState(user: Profile, status: Int, reason: String, end: Double) {
        if (user.status != status || user.reason != reason || user.end != end){
            var endV = end
            if endV < Date().timeIntervalSince1970 {
                endV = (Date().timeIntervalSince1970 + 4*60*60)
            }
            mateDB.document(user.uid).updateData(["reason": reason,"status": status, "end": endV, "start": Date().timeIntervalSince1970])
        }
    }
    
    func noStatus(id: String){
        mateDB.document(id).updateData(["reason": "", "status": -1])
    }
}


class Fire: ObservableObject {
    
    @Published var isUserAuthenticated: FireAuthState = .undefined
    @Published var profile: Profile = Profile(uid: "", name: "", reason: "", status: -1, end: Date().timeIntervalSince1970, start: Date().timeIntervalSince1970, house: "")
    @Published var houseName: String = "Home"
    @Published var timeSelection: Int = 9
    @Published var reasons: [String] = ["👩‍💻 Working", "📺 Watching TV", "🏃‍♂️ Exercising", "📱 On the phone"]
    
    
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
    
    
    func changeStatus(_ newStat: Int){
        db.collection("profiles").document(self.profile.uid).updateData(["status": newStat])
    }
    
    func startListener() {
        self.error = nil
        DispatchQueue.main.async {
            self.reasons = self.userDefaults.object(forKey: "reasons") as? [String] ?? ["👩‍💻 Working", "📺 Watching TV", "🏃‍♂️ Exercising", "📱 On the phone"]
        }
        repository.startListener(Fid: self.profile.house, userID: self.profile.uid, result: {[weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let items):
                self.mates = items
                //self.getHouseName() - CALLED MULTIPLE TIMES, MOVED TO LATER
            case .failure(let error):
                //self.repository.startListener(Fid: self.profile.house, userID: self.profile.uid, result: {_ in })
                self.error = error
            }
            self.getHouseName()
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
        DispatchQueue.main.async {
            self.userDefaults.set(self.reasons, forKey: "reasons")
        }
        repository.stopListener()
    }
    
    //not fully functional
    func signOut(){
        self.isUserAuthenticated = .signedOut
    }
    
    func testHouse(_ houseId: String, completionHandler: @escaping (Result<Bool, houseError>) -> Void) {
        self.db.collection("Homes").document(houseId).getDocument { (document, error) in
            if let document = document, document.exists {
                completionHandler(.success(true))
            } else {
                completionHandler(.failure(.badQR))
            }
            //completionHandler(.failure(.badQR)) - DON'T THINK THIS IS NECESSARY BUT CAN POTENTIALLY USE LATER
        }
    }
    
    
    func saveState(user: Profile, status: Int, reason: String, end: Double) {
        profile.end = end
        profile.start = Date().timeIntervalSince1970
        repository.saveState(user: user, status: status, reason: reason, end: end)
    }
    
    let userDefaults = UserDefaults.standard
    
    func saveCustomReasons(reasons: [String]){
        self.reasons = reasons
    }
    
    func getCustomReasons() -> [String] {
        return self.reasons
    }
    
    func changeName(_ newName: String) {
        self.profile.name = newName
        db.collection("profiles").document(self.profile.uid).updateData(["name": newName])
    }
    
    func quickUpdateTime(_ selection: Int, profile: Profile){
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
            x = Int(Calendar.current.nextDate(after: Date(), matching: DateComponents(hour: 0, minute: 0), matchingPolicy: .nextTimePreservingSmallerComponents)!.timeIntervalSince1970 - Date().timeIntervalSince1970)//until midnight
        default:
            x = 60 * 60 * 4
        }
        self.profile.end = Double(x) + Date().timeIntervalSince1970 + 60
        repository.qUpdateTime(profile, selection)
        //db.collection("profiles").document(self.profile.uid).updateData(["end": (profile.end + (10*60*Double(state)))])
    }
    
    func noStatus(_ id: String){
        for i in 0 ..< mates.count {
            let mate = mates[i]
            if mate.id == id && mate.status > -1 {
                repository.noStatus(id: id)
                return
            }
        }
    }
    
    func noStatus(){
        if (self.profile.status >= 0){
            self.profile.reason = ""
            self.profile.status = -1
            repository.noStatus(id: self.profile.uid)
        }
    }
    
    func setHouseName(_ newName: String) {
        self.houseName = newName
        db.collection("Homes").document(self.profile.house).updateData(["name": newName])
    }
    
    func getHouseName() {
        let docRef = db.collection("Homes").document(self.profile.house)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let hName = document.get("name") as? String ?? "Home"
                self.houseName = hName
                //print("houseName: \(hName)")
            } else {
                print("Document does not exist")
            }
        }
    }
}
