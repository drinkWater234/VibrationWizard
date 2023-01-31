//
//  User.swift
//  VibrationWizard
//
//  Created by Consultant on 1/27/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

typealias ID = String

struct TheUser: Codable
{
    var username: String
    var profileName: String
    let email: String
    let userID: String
    var vibrateStatus: Bool
    
    var contactsRefPath = ""
    var contactsCollection: CollectionReference
    {
        Firestore.firestore().collection(contactsRefPath)
    }
    
    var groupsInvolvedRefPath = ""
    var groupsInvolvedCollection: CollectionReference
    {
        Firestore.firestore().collection(groupsInvolvedRefPath)
    }
    
    var friendRequestsRefPath = ""
    var friendRequestsCollection: CollectionReference
    {
        Firestore.firestore().collection(friendRequestsRefPath)
    }
    
    var groupInvitesRefPath = ""
    var groupInvitesCollection: CollectionReference
    {
        Firestore.firestore().collection(groupInvitesRefPath)
    }
    
    private enum CodingKeys: String, CodingKey
    {
        case username, profileName, email, userID, vibrateStatus
        case contactsRefPath, groupsInvolvedRefPath
        case friendRequestsRefPath, groupInvitesRefPath
    }
}

