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
    // MARK: - QUICK ACTION
    @Published var quickAction: Status? = nil {
        didSet {
            quickActionChange()
        }
    }
    
    func quickActionChange() {
        if let qA = self.quickAction {
            self.quickUpdateStatus(status: qA, profile: self.profile)
            self.quickAction = nil
        }
    }
    
    
    // MARK: - Auth
    
    @Published var isUserAuthenticated: FireAuthState = .undefined
    @Published var profile: Profile = Profile(uid: "", name: "", reason: "", status: .green, end: Date().timeIntervalSince1970, start: Date().timeIntervalSince1970, house: "", pushToken: "")
    @Published var houseName: String = "Home"
    @Published var timeSelection: Int = 9
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    let db = Firestore.firestore()
    private var pushSender = PushNotificationSender()
    
    
    
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
                    if let qA = self.quickAction {
                        self.quickUpdateStatus(status: qA, profile: self.profile)
                    }
                    Crashlytics.crashlytics().setUserID(profile.uid)
                    DispatchQueue.global(qos: .default).async {
                        self.getDefaults()
                    }
                    self.updateFirestorePushToken()
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
            self.isUserAuthenticated = .signedIn
        })
    }
    
    //MARK: - APP CLOSING
    
    func appWillClose() {
        Fire.userDefaults.set(self.reasons, forKey: "reasons")
    }
    
    // MARK: - NOTIFICATIONS
    //saves the last notification sent to see if time difference > 2 minutes or different status
    @Published var lastNotification = NotificationStruct(status: nil, reason: nil, endTime: nil, sendTime: nil)
    
    //indicates to homeview to display notification sent UI
    @Published var isShowingNotification = false
    
    func updateFirestorePushToken() {
        if let token = Messaging.messaging().fcmToken {
            self.profile.pushToken = token
            let usersRef = Firestore.firestore().collection("profiles").document(self.profile.uid)
            usersRef.setData(["pushToken": token], merge: true)
        }
    }
    
    func showNotification(){
        isShowingNotification = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isShowingNotification = false
        }
    }
    
    func remindMate(_ token: String) {
        pushSender.sendPushNotification(to: token, title: messageTitle(), body: messasageBody())
        showNotification()
    }
    
    func testPush() {
        pushSender.sendPushNotification(to: "et_uzsZta0kkvh7Dc2-lAN:APA91bGIz3ieYLCq3_Zywlhmt_Kc4MGldA58xpom4Of-vUAzz17P31gU-KdlJc4CL26jGSg-9YSKHSsHPCxRTiTn6rgz0A5wpy06pxWA1X0t6GSbUf5qGlOXTTR0p1ixrLd9G4CnuJno", title: "Test", body: "hey dad")
    }
    
    func remindHouse() {
        let notif = NotificationStruct(status: self.profile.status, reason: self.profile.reason, endTime: self.profile.end, sendTime: Date().timeIntervalSince1970)
        /*print("checkSend: Last notif \(lastNotification)")
        print("checkSend: currentStatus: \(self.profile.status) : currentReason: \(self.profile.reason)")
        print("checkSend: New notif \(notif)")*/
        if lastNotification.check(canSend: notif) {
            buttonPressHaptic(self.reduceHaptics)
            self.lastNotification = notif
            showNotification()
            for mate in self.mates {
                pushSender.sendPushNotification(to: mate.pushToken, title: messageTitle(), body: messasageBody())
            }
        } else {
            errorHaptic(self.reduceHaptics)
        }
    }
    
    func messageTitle() -> String {
        var ret = self.profile.name
        switch self.profile.status {
        case .red:
            ret += " says Shoo"
        case .yellow:
            ret += " says Quiet"
        case .green:
            ret += " is Free"
        }
        return ret
    }
    
    func messasageBody() -> String {
        let reason = self.profile.reason
        if reason.isEmpty {
            return "For \(timeElement())"
        }
        return "\(self.profile.reason) for \(timeElement())"
    }
    
    func timeElement() -> String{
        let timeLeft = self.profile.end - Date().timeIntervalSince1970
        if timeLeft > 8*60*60 {
            return "all day"
        } else if timeLeft <= 0 {
            return "a while"
        }
        else if timeLeft > 4*60*60 {
            return "a while"
        } else {
            let hours = Int(timeLeft/3600)
            let minutes = Int((timeLeft/60).truncatingRemainder(dividingBy: 60))
            return (hours>0 ? "\(hours) hour\(hours == 1 ? "" : "s")": "") + (hours > 0 && minutes > 0 ? ", " : "") + (minutes>0 ? "\(minutes) minute\(minutes == 1 ? "" : "s")": "")
        }
    }
    
    // MARK: - STATUS LISTENERS
    @Published var mates: [Mate] = []
    @Published var error: Error? = nil
    var repository = HouseRepository()
    
    
    func changeStatus(_ newStatus: Status){
        db.collection("profiles").document(self.profile.uid).updateData(["status": newStatus.rawValue])
    }
    
    func startListener() {
        self.error = nil
        DispatchQueue.main.async {
            self.reasons = Fire.self.userDefaults.object(forKey: "reasons") as? [String] ?? ["Working", "Watching TV", "Exercising", "On the phone"]
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
    
    func stopListener() {
        DispatchQueue.main.async {
            Fire.self.userDefaults.set(self.reasons, forKey: "reasons")
        }
        repository.stopListener()
    }
    
    //not fully functional
    func signOut(){
        self.isUserAuthenticated = .signedOut
    }
    
    //MARK: - REASONS
    
    static let userDefaults = UserDefaults.standard
    @Published var reasons: [String] = ["👩‍💻 Working", "📺 Watching TV", "🏃‍♂️ Exercising", "📱 On the phone"]
    
    func saveCustomReasons(reasons: [String]){
        self.reasons = reasons
        Fire.userDefaults.set(self.reasons, forKey: "reasons")
    }
    
    func getCustomReasons() -> [String] {
        return self.reasons
    }
    
    func updateMates(houseId: String) {
        self.repository.startListener(Fid: houseId, userID: self.profile.uid, result: {[weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let items):
                self.mates = items
            case .failure(let error):
                //self.repository.startListener(Fid: self.profile.house, userID: self.profile.uid, result: {_ in })
                self.error = error
            }
        } )
    }
    
    // MARK: - UPDATE STATE
    
    func saveState(user: Profile, status: Status, reason: String, end: Double) {
        profile.end = end
        profile.start = Date().timeIntervalSince1970
        repository.saveState(user: user, status: status, reason: reason, end: end)
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
            x = Int(Date.distantFuture.timeIntervalSince1970)
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
    
    // MARK: - HOUSE
    func setHouseName(_ newName: String) {
        self.houseName = newName
        db.collection("Homes").document(self.profile.house).updateData(["name": newName])
        self.getHouseName()
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
    
    func updateHouse(_ prof: Profile, _ oldID: String){
        repository.updateHouse(prof, oldID)
    }
    
    func createHouse() -> String {
        return self.repository.createHouse(uid: self.profile.uid)
    }
    
    
    // MARK: - Saved Accessibility Settings
    @Published var reduceHaptics: Bool = false {
        didSet {
            Fire.userDefaults.set(self.reduceHaptics, forKey: "reduceHaptics")
            print("Saved toggle")
        }
    }
    //let userDefaults = UserDefaults.standard
    
    func getDefaults() {
        DispatchQueue.main.async {
            self.reduceHaptics = Fire.userDefaults.object(forKey: "reduceHaptics") as? Bool ?? false
        }
    }
    
    func reduceHaptics(_ state: Bool) {
        DispatchQueue.main.async {
            self.reduceHaptics = state
            Fire.userDefaults.set(self.reduceHaptics, forKey: "reduceHaptics")
        }
    }
    
    
}
