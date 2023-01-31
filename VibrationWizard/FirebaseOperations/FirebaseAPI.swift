//
//  FirebaseAPI.swift
//  VibrationWizard
//
//  Created by Consultant on 1/27/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class FirebaseAPI
{
    private var db = Firestore.firestore()
    
    var subs = Set<AnyCancellable>()
    

}

// Create Account Page
extension FirebaseAPI
{
    func addNewUser(email: String, password: String, username: String, profileName: String) -> Future<Bool, Never>
    {
        return Future { promise in
            Auth.auth().createUser(withEmail: email, password: password)
            {
                [weak self] authDataReuslt, error in
                
                if let authDataReuslt, error == nil
                {
                    let newDocPath = try! self?.db.collection("User").addDocument(from: TheUser(username: username,
                                                                                 profileName: profileName,
                                                                                 email: email,
                                                                                 userID: authDataReuslt.user.uid,
                                                                                 vibrateStatus: false))
                                                                   .path
                    self?.db.document(newDocPath!).updateData(["contactsRefPath" : newDocPath!+"/Contacts"])
                    self?.db.document(newDocPath!).updateData(["groupsInvolvedRefPath" : newDocPath!+"/GroupsInvolved"])
                    self?.db.document(newDocPath!).updateData(["friendRequestsRefPath" : newDocPath!+"/FriendRequests"])
                    self?.db.document(newDocPath!).updateData(["groupInvitesRefPath" : newDocPath!+"/GroupInvites"])
                    promise(.success(true))
                    
                } else if let error {
                    print(error.localizedDescription)
                    promise(.success(false))
                }
            }
        }
        
    }
    
    
    func checkForExistingEmail(email: String) -> Future<Bool, Never>
    {
        return Future
        {
            [unowned self] promise in
            self.db.collection("User").whereField("email", isEqualTo: email).getDocuments
            {
                snapshot, error in
                guard let snapshot else {print(error!.localizedDescription); return}

                precondition(snapshot.documents.count <= 1, "Found more than one user with the same email, this is an error")
                if snapshot.documents.count == 1
                {
                    promise(.success(true))
                } else {
                    promise(.success(false))
                }
            }
        }
    }
     
    
    
    func checkForExistingUsername(username: String) -> Future<Bool, Never>
    {
        return Future { [unowned self]
            
            promise in
            db.collection("User").whereField("username", isEqualTo: username).getDocuments
            {
                snapshot, error in
                guard let snapshot else {print(error!.localizedDescription); return}
                precondition(snapshot.documents.count <= 1, "Found more than one user with the same username, this is an error")
                if snapshot.documents.count == 1
                {
                    promise(.success(true))
                } else {
                    promise(.success(false))
                }
            }
        }
    }
}

// Login Page
extension FirebaseAPI
{
    func login(email: String, password: String) -> Future<Bool, Never>
    {
        return Future { promise in
            Auth.auth().signIn(withEmail: email, password: password)
            {
                authDataResult, error in
                if let error
                {
                    let authError = error as! AuthErrorCode
                    switch authError.code
                    {
                    case .wrongPassword:
                        print("Wrong Password")
                    case .invalidEmail:
                        print("malformed email")
                    case .userNotFound:
                        print("Email not in database")
                    default:
                        print(authError.localizedDescription + "\nError Code: \(authError.errorCode)")
                    }
                    promise(.success(false))
                } else if let authDataResult {
                    print("Logined in with: \(authDataResult.user.email!)")
                    promise(.success(true))
                }
            }
        }
    }
}

// Recent and Contact Page
extension FirebaseAPI
{
    func set_GroupsInvolved_FriendRequests_GroupInvites(userID: ID)
    {
        db.collection("User").whereField("userID", isEqualTo: userID).getDocuments
        {
            querySnapshot, error in
            
            if let error
            {
                print(error.localizedDescription)
            } else if let querySnapshot {
                precondition(querySnapshot.count == 1, "Two documents with the same userID. This should not happen.")
                
                querySnapshot.documents[0].reference.collection("GroupsInvolved").getDocuments
                {
                    snapshot, error in
                    
                    if let error
                    {
                        print(error.localizedDescription)
                    }
                    
                    if let snapshot
                    {
                        var GroupsInvolved =
                        snapshot.documents.map { documentSnapshot in
                            documentSnapshot["groupID"] as! String
                        }
                        
                        print(GroupsInvolved)
                    }
                }
                
                querySnapshot.documents[0].reference.collection("FriendRequests").getDocuments
                {
                    snapshot, error in
                    
                    if let error
                    {
                        print(error.localizedDescription)
                    }
                    
                    if let snapshot
                    {
                        var FriendRequests = snapshot.documents.map { documentSnapshot in
                            documentSnapshot["FriendRequestID"] as! String
                        }
                        
                        print(FriendRequests)
                    }
                }
                
                querySnapshot.documents[0].reference.collection("GroupInvites").getDocuments
                {
                    snapshot, error in
                    
                    if let error
                    {
                        print(error.localizedDescription)
                    }
                    
                    if let snapshot
                    {
                        var GroupInvites = snapshot.documents.map { documentSnapshot in
                            documentSnapshot["GroupInvites"] as! String
                        }
                        
                        print(GroupInvites)
                    }
                }
            }
        }
    }
}

// Create new group page
extension FirebaseAPI
{
    func addGroup(groupToAdd: Group, usersInvited: [ID])
    {
        do
        {
            guard let currentUserID = Auth.auth().currentUser?.uid else
            {
                print("Must login first")
                return
            }
            
            precondition(groupToAdd.members.contains(currentUserID), "Founder should always be a Group member")
            
            // Add new group Entity to Group Collection
            let newDocReference = try db.collection("Group").addDocument(from: groupToAdd)
            let newDocID = newDocReference.documentID
            // Set groupID
            newDocReference.updateData(["groupID": newDocID]) { error in
                if let error {print(error.localizedDescription)}
            }
            
            // Set group member's collectino path
            newDocReference.updateData(["membersRefPath": "\(newDocReference.path)/Members"]) { error in
                if let error {print(error.localizedDescription)}
            }
            
            
            
            // Send group invites(s)
            try usersInvited.forEach { toUserID in
                if toUserID != currentUserID
                {
                    try sendGroupInvite(founderUserID: currentUserID, toUser: toUserID, groupID: newDocID)
                }
            }
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func sendGroupInvite(founderUserID: ID, toUser:ID, groupID: ID) throws
    {
        // New GroupInvite instance
        let newNotification = TheGroupInvite(founder: founderUserID, to: toUser,
                                              timeSent: Timestamp(date: .now),
                                              accepted: NotificationStatus.pending,
                                              groupID: "",
                                              type: "GroupInvite")
        
        // Add GroupInvite instance to Notifications collection
        let newDocReference = try db.collection("Notifications").addDocument(from: newNotification)
        let newDocID = newDocReference.documentID
        newDocReference.updateData(["groupID" : newDocID])
        
        // Add GroupInvite instance collection path to target user's groupInvites Collection
        db.collection("User").whereField("userID", isEqualTo: toUser).getDocuments
        {
            snapshot, error in
            guard let snapshot else {return}
            precondition(snapshot.documents.count == 1, "Should only have one document with a unique user ID")
            let userGroupInviteCollectionPath = snapshot.documents[0]["groupInvitesRefPath"] as! String
            precondition(userGroupInviteCollectionPath != "", "groupInvitesRefPath should not be an empty string")
            self.db.collection(userGroupInviteCollectionPath).addDocument(data: ["GroupInvitePath" : newDocReference.path])
        }
    }
    
}

// Notification Page
extension FirebaseAPI
{
    
    func userAcceptedGroupInvite(groupInviteID: ID)
    {
        // Add GroupID to user's GroupInvolved collection
        // Add userID to to the group
        // Remove notification from user's GroupInvite
        // Remove notification from database
        
        // Need to get GroupID from groupInvite to add to user's GroupInvolved collection
        // Need to get group member's ref path to add userID to group's member collection
        
        // Need to get userID from groupInvite to get user's groupInviteRef path
        // Need to get user's groupInviteRef path to delete the notification from user's groupInvite collection
        
    }
    
    //private func getGroupInvite(groupInviteID: ID) -> Future<TheGroupInvite, Error>
    
}

// Invite users to group page
extension FirebaseAPI
{
    // Send group invite function already defined above
    
    func getUserContacts(userID: ID) /*async*/ -> Future<[TheUser], Never>
    {
        /*
        let path = await getUserContactsRefPath(userID: userID).value
        return Future { promise in
            self.db.collection(path).getDocuments { snapshot, error in
                guard let snapshot else {print(error!.localizedDescription); return}
                let contacts = snapshot.documents.map
                {
                    docSnapshot in
                    return try! docSnapshot.data(as: TheUser.self)
                }
                promise(.success(contacts))
            }
        }
         */
        
        return Future { promise in
            self.getUserContactsID(userID: userID).sink { userIDs in
                self.db.collection("User").whereField("userID", in: userIDs).getDocuments { snapshot, error in
                    guard let snapshot else {print(error!.localizedDescription); return}
                    let results = snapshot.documents.map { docSnapshot in
                        try! docSnapshot.data(as: TheUser.self)
                    }
                    promise(.success(results))
                }
            }.store(in: &self.subs)
        }
        
        
    }
    
    func getUserContactsID(userID: ID) -> Future<[String], Never>
    {
        return Future { promise in
            self.getUserContactsRefPath(userID: userID).sink { userContactRefPath in
                self.db.collection(userContactRefPath).getDocuments { snapshot, error in
                    guard let snapshot else {print(error!.localizedDescription); return}
                    print(userContactRefPath)
                    let contacts = snapshot.documents.map
                    {
                        docSnapshot in
                        
                        let userIDs = docSnapshot.data()
                        return userIDs["userID"] as! String
                        
                        //return try! docSnapshot.data(as: userIDs)
                    }
                    promise(.success(contacts))
                }
            }.store(in: &self.subs)
        }
    }
    
    func getUserContactsRefPath(userID: ID) -> Future<String, Never>
    {
        return Future { promise in
            self.db.collection("User").whereField("userID", isEqualTo: userID).getDocuments { snapshot, error in
                guard let snapshot else {print(error!.localizedDescription); return}
                precondition(snapshot.documents.count == 1, "Found no documents with specified userID, or more than one documents with the same userID")
                let contactsRefPath = snapshot.documents[0]["contactsRefPath"] as! String
                precondition(contactsRefPath != "", "contactsRefPath should not be an empty string")
                promise(.success(contactsRefPath))
            }
        }
    }
}

