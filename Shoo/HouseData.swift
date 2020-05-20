//
//  HouseData.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/17/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase
import SwiftUI




class HouseData: ObservableObject {
    var houseName: String = "Home"
    @Published var mates: [Mate] = []

    var mateList: [String] = []
    
    let db = Firestore.firestore()
    
   



/*
 public func getHouse(userID: String){
 print(userID)
 houseID = ""
 let homesRef = db.collection("Houses")
 
 //gets the id for each house - CAN LATER IMPLEMENT TO INCLUDE MULTIPLE HOUSES
 _ = homesRef.whereField("Mates", arrayContains: userID).getDocuments() { (querySnapshot, err) in
 if let err = err {
 print("Error getting documents: \(err)")
 } else {
 for document in querySnapshot!.documents {
 self.houseID = document.documentID
 print("\(document.documentID) => \(document.data())")
 }
 }
 }
 //if a house exists
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
 }
 db.collection("profiles").whereField("uid", in: mateList)
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
 
 self.mates.append(Mate(id: id, name: name, reason: reason, status: status, end: end))
 }
 }
 }
 //no house exists - create house
 else {
 createHouse(uid: userID)
 }
 }
 */

