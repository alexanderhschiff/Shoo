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
    
    func startListener(Fid: String, result: @escaping (Result<[Mate], Error>) -> Void) {
        stopListener()
        var mateIDs: [String] = []
        hListener = houseDB
            .document(Fid)
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
                let houses = documents.get("mates") as? [String] ?? ["noMates"]
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
    
    func addMate(_ mate: Mate) {
        mateDB.document(mate.id).setData(mate.toJSONSnapshot)
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
}
class Fire: ObservableObject {
    
    @Published var isUserAuthenticated: FireAuthState = .undefined
    @Published var profile: Profile = Profile(uid: "", name: "", reason: "", status: 0, end: Date(), house: "testHouse")
    @Published var houseID: String = UserDefaults.standard.string(forKey: "houseId") ?? "noHouse"

    
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
        
        repository.startListener(Fid: self.profile.house, result: {[weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let items):
                self.mates = items
                
            case .failure(let error):
                self.error = error
            }
        } )
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
    
    func stopListener() {
        repository.stopListener()
    }
    
    func signOut(){
        self.isUserAuthenticated = .signedOut
    }
    private func createHouse(uid: String) {
        //create a new house and add myself
        var ref: DocumentReference? = nil
        let db = Firestore.firestore()
        ref = db.collection("Houses").addDocument(data: [
            "name": "house",
            "Mates": [uid]
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        houseID = ref?.documentID ?? ""
        db.collection("profiles").document(uid).setValue(houseID, forKey: "house")
    }
}



struct Fire_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

/*
 public func getHouse(houseID: String, userID: String){
 self.houseID = houseID
 
 if (houseID != ""){
 db.collection("Houses").document(houseID)
 .addSnapshotListener { documentSnapshot, error in
 guard let document = documentSnapshot else {
 print("Error fetching document: \(error!)")
 return
 }
 guard let data = document.data() else {
 self.createHouse(uid: userID)
 print("Document data was empty.")
 return
 }
 self.mateList = document.get("Mates") as! [String]
 dump(self.mateList)
 }
 self.mateList.append("test1")
 if(self.mateList != []){
 db.collection("profiles").whereField("id", in: mateList)
 .addSnapshotListener { snap, err in
 if err != nil{
 self.createHouse(uid: userID)
 return
 }
 for i in snap!.documentChanges{
 
 let id = i.document.documentID
 let name = i.document.get("name") as! String
 let reason = i.document.get("reason") as! String
 let status = i.document.get("status") as! Int
 let end = i.document.get("end") as? Date
 print(name)
 self.mates.append(Mate(id: id, name: name, reason: reason, status: status, end: end))
 }
 }
 }
 }
 //no house exists - create house
 else {
 createHouse(uid: userID)
 }
 */
