//
//  ViewController.swift
//  VibrationWizard
//
//  Created by Consultant on 1/25/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Combine

class ViewController: UIViewController {
    
    let myFirebaseAPI = FirebaseAPI()
    
    
    //let db = Firestore.firestore()
    var mySub: AnyCancellable!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //view.backgroundColor = .systemBlue
        //myFirebaseAPI.addNewUser(email: "myKitt@gmail.com", password: "meeKitty!", username: "blyat", profileName: "drinkWater2")
        //myFirebaseAPI.addNewUser(email: "bonzai@gmail.cm", password: "meowmewow@", username: "kitty", profileName: "ALpha")
        //myFirebaseAPI.addNewUser(email: "plankkie@gmail.com", password: "beezWacks!", username: "cappy", profileName: "boi")
        //myFirebaseAPI.checkForExistingUsername(username: "asdfadsf")
        //myFirebaseAPI.checkForExistingEmail(email: "bonzai@gmail.cm")
        
        //myFirebaseAPI.checkLoginInformation(email: "myKitt@gmail.com", password: "meeKitty!")
        //myFirebaseAPI.set_GroupsInvolved_FriendRequests_GroupInvites(userID: "RVNM1TGfJ0VAkBKHEXQB5WsDvcW2")
        
        /*
        let _ = try! db.collection("Group").addDocument(from: TheFriendRequest(from: "1",
                                                                               to: "2",
                                                                               timeSent: Timestamp(date: Date.now),
                                                                               accepted: .pending,
                                                                               friendRequestID: "9"))
         */
        
        /*
        myFirebaseAPI.addGroup(groupToAdd: Group(groupName: "Foodies",
                                                 founder: "999",
                                                 groupID: "111",
                                                 vibrateStatus: false,
                                                 members: ["0", "3"]
                                                 ))
         */
        
        
        
        //myFirebaseAPI.checkLoginInformation(email: "myKitt@gmail.com", password: "meeKitty!")
        /*
        mySub = myFirebaseAPI.login(email: "myKitt@gmail.com", password: "meeKitty!")
            .sink { completionState in
                switch completionState
                {
                case .finished:
                    print("Logged In")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { authDataResult in
                var testGroup = Group(groupName: "MyFirstGroup",
                                      founder: Auth.auth().currentUser!.uid,
                                      groupID: "",
                                      vibrateStatus: false,
                                      members: ["FL8WFIThRUUTP89Tu8V8tuhudMp1"])
                print(testGroup)
                self.myFirebaseAPI.addGroup(groupToAdd: testGroup, usersInvited: ["JSWAJdurp9PO3cAUqBCMOqRskzb2", "FL8WFIThRUUTP89Tu8V8tuhudMp1"])
            }
         */
        
        /*
        mySub = myFirebaseAPI.getUserContacts(userID: "FL8WFIThRUUTP89Tu8V8tuhudMp1").sink(receiveValue: { allContacts in
            allContacts.forEach { theUser in
                print(theUser)
            }
        })
         */
        
    }
}

