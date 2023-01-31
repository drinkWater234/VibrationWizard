//
//  Group.swift
//  VibrationWizard
//
//  Created by Consultant on 1/28/23.
//

import Foundation
import FirebaseFirestore

typealias DocumentPath = String

struct Group: Codable
{
    let groupName: String
    let founder: ID
    let groupID: ID
    var vibrateStatus: Bool
    
    var membersRefPath: DocumentPath = ""
    var membersCollection: CollectionReference
    {
        precondition(membersRefPath != "", "mebersRefPath should not be an empty string before using this variable")
        return Firestore.firestore().collection(membersRefPath)
    }
    var members: Set<ID> = []
    
    private enum CodingKeys: String, CodingKey
    {
        case groupName, founder, groupID, vibrateStatus, membersRefPath
    }
}


/*
 
 private mutating func setMembers(completion: @escaping (Result<[ID], Error>) -> Void)
 {
     guard let membersCollection else {return}
     membersCollection.addSnapshotListener { snapshot, error in
         guard let snapshot else { print(error!.localizedDescription); return}
         snapshot.documentChanges.forEach { documentChange in
             let userID = documentChange.document["userID"] as! ID
             switch documentChange.type
             {
             case .added:
                 
                 if !members.contains(userID)
                 {
                     members.insert(userID)
                 }
             case .removed:
                 precondition(members.contains(userID), "The removed ID should have already been in array")
                 members.remove(userID)
             case .modified:
                 fatalError("User ID in Group should never be modified. Only added or removed.")
             }
         }
     }
 }
 
 */

