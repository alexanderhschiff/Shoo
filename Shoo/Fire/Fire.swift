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



class Fire: ObservableObject {
    
    @Published var isUserAuthenticated: FireAuthState = .undefined
    @Published var profile: Profile = Profile(uid: "", name: "", reason: "", status: .green, end: Date().timeIntervalSince1970, start: Date().timeIntervalSince1970, house: "", pushToken: "")
    @Published var houseName: String = "Home"
    @Published var timeSelection: Int = 9
    @Published var reasons: [String] = ["👩‍💻 Working", "📺 Watching TV", "🏃‍♂️ Exercising", "📱 On the phone"]
    
    
    var mateList: [String] = []
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    let db = Firestore.firestore()
    private var pushSender = PushNotificationSender()
    
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
                    self.updateFirestorePushToken(uid: self.profile.uid)
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
            self.isUserAuthenticated = .signedIn
        })
    }
    
    func updateFirestorePushToken(uid: String) {
        if let token = Messaging.messaging().fcmToken {
            self.profile.pushToken = token
            let usersRef = Firestore.firestore().collection("profiles").document(uid)
            usersRef.setData(["pushToken": token], merge: true)
        }
    }
    
    func remindHouse() {
        pushSender.sendPushNotification(to: "dfN38DhWMUktjpNaHsD-Lo:APA91bF1wZtoo3n0llhesoM05V1VIQmaZ-QdUURApQrRtZ1-kV2yZSfByFI_g59Ijq_k_at7PVRULCt15k2yBhd_2rHYU-825Vy_XCpQrHBsgbq8wGHgmQG28TH5e1XiWfs5pZRiJdsv", title: "Test", body: "hey ben")
    }
    
    @Published var mates: [Mate] = []
    @Published var error: Error? = nil
    var repository = HouseRepository()
    
    
    func changeStatus(_ newStatus: Status){
        db.collection("profiles").document(self.profile.uid).updateData(["status": newStatus.rawValue])
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
            case .failure(let error):
                //self.repository.startListener(Fid: self.profile.house, userID: self.profile.uid, result: {_ in })
                self.error = error
            }
        } )
        self.getHouseName()
    }
    
    
    func quickUpdateStatus(status: Status, profile: Profile) {
        repository.qUpdateStatus(status, profile)
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
    
    
    func saveState(user: Profile, status: Status, reason: String, end: Double) {
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
            if mate.id == id && mate.status != .green {
                repository.noStatus(id: id)
                return
            }
        }
    }
    
    func noStatus(){
        if (self.profile.status != .green){
            self.profile.reason = ""
            self.profile.status = .green
            repository.noStatus(id: self.profile.uid)
        }
    }
    
    func setHouseName(_ newName: String) {
        self.houseName = newName
        db.collection("Homes").document(self.profile.house).updateData(["name": newName])
    }
    
    func getHouseName() {
        if (self.profile.house != "") {
            let docRef = db.collection("Homes").document(self.profile.house)
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let hName = document.get("name") as? String ?? "Home"
                    self.houseName = hName
                    print("houseName: \(hName)")
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
}
