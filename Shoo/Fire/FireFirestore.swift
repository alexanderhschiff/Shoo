//
//  FireFirestore.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/17/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import FirebaseFirestore

struct FireFirestore {
    
    static func retreiveProfile(uid: String, result: @escaping (Result<Profile, Error>) -> ()) {
        let reference = Firestore
            .firestore()
            .collection(FireKeys.CollectionPath.profiles)
            .document(uid)
            .addSnapshotListener{ (snapshot, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            
            guard let documents = snapshot else {
                result(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Snapshot is empty"])))
                return
            }
            
                let data = documents.data()
                let prof = Profile(documentData: data!)!
                result(.success(prof))
        }
            /*
                switch result {
            case .success(let data):
                guard let profile = Profile(documentData: data) else {
                    completion(.failure(FireAuthError.noProfile))
                    return
                }
                completion(.success(profile))
            case .failure(let err):
                completion(.failure(err))
            }*/
        }
        
    
    static func mergeProfile(_ data: [String: Any], uid: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        let reference = Firestore
            .firestore()
            .collection(FireKeys.CollectionPath.profiles)
            .document(uid)
        reference.setData(data, merge: true) { (err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            completion(.success(true))
        }
    }
    
    static func getDocument(for reference: DocumentReference, completion: @escaping (Result<[String : Any], Error>) -> ()) {
        reference.getDocument { (documentSnapshot, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let documentSnapshot = documentSnapshot else {
                completion(.failure(FireAuthError.noDocumentSnapshot))
                return
            }
            guard let data = documentSnapshot.data() else {
                completion(.failure(FireAuthError.noSnapshotData))
                return
            }
            completion(.success(data))
        }
    }
}

