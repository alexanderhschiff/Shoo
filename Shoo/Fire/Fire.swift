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
		if fid == "" {
			fid = createHouse(uid: userID)
			mateDB.document(userID).setData([ "house": fid ], merge: true)
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
	
	func createHouse(uid: String) -> String{
		//xvar houseID = UserDefaults.standard.string(forKey: "houseId") ?? ""
		//create a new house and add myself
		var ref: DocumentReference? = nil
		ref = houseDB.addDocument(data: [
			"name": "house",
			"Mates": [uid]
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
		houseDB.document(prof.house).updateData(["mates": FieldValue.arrayUnion([prof.uid])])
		houseDB.document(oldID).updateData(["mates": FieldValue.arrayRemove([prof.uid])])
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
		if(statusInt != profile.status) {
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
	
	func qUpdateTime(_ state: Double, _ profile: Profile){
		var prof = profile
		//dump(prof.end)
		prof.end = profile.end + (10 * 60 * state)
		//dump(prof.end)
		mateDB.document(prof.uid).updateData(["end": prof.end])
	}
	
	func saveState(user: Profile, status: Int, reason: String, end: Double) {
		if (user.status != status || user.reason != reason || user.end != end){
            mateDB.document(user.uid).updateData(["reason": reason,"status": status, "end": end, "start": Date().timeIntervalSince1970])
		}
	}
	
	
}
class Fire: ObservableObject {
	
	@Published var isUserAuthenticated: FireAuthState = .undefined
    @Published var profile: Profile = Profile(uid: "", name: "", reason: "", status: -1, end: Date().timeIntervalSince1970, start: Date().timeIntervalSince1970, house: "")
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

	
	func changeStatus(_ newStat: Int){
		db.collection("profiles").document(self.profile.uid).updateData(["status": -1])
	}
	
	func startListener() {
		self.error = nil
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
	
	//not fully functional
	func signOut(){
		self.isUserAuthenticated = .signedOut
	}
	
    func testHouse(_ houseId: String) -> Bool{
        /*
         let semaphore = DispatchSemaphore(value: 1)
         var outP = false
         DispatchQueue.global(qos: .userInteractive).async {
         var out = false
         self.db.collection("Homes").document(houseId).getDocument { (document, error) in
         semaphore.wait()
         //print("waiting")
         out = ((document?.exists) != nil)
         }
         outP = out
         //print("signal")
         semaphore.signal()
         }
         //print(outP)
         */
        return true
    }
	
	
	func saveState(user: Profile, status: Int, reason: String, end: Double) {
		repository.saveState(user: user, status: status, reason: reason, end: end)
	}
	
	let userDefaults = UserDefaults.standard
	
	func saveCustomReasons(reasons: [String]){
		userDefaults.set(reasons, forKey: "reasons")
	}
	
	func getCustomReasons() -> [String] {
		return userDefaults.object(forKey: "reasons") as? [String] ?? ["👩‍💻 Working", "📺 Watching TV", "🏃‍♂️ Exercising", "📱 On the phone"]
	}
	
	func changeName(_ newName: String) {
		self.profile.name = newName
		db.collection("profiles").document(self.profile.uid).updateData(["name": newName])
	}
	
	func quickUpdateTime(_ state: Int, profile: Profile){
        self.profile.end = profile.end + (10*60*Double(state))
        repository.qUpdateTime(Double(state), profile)
		//db.collection("profiles").document(self.profile.uid).updateData(["end": (profile.end + (10*60*Double(state)))])
	}
    
    func noStatus(_ id: String){
        for i in 0 ..< mates.count {
            var mate = mates[i]
            if mate.id == id {
                mate.status = -1
                return
            }
        }
    }
}
