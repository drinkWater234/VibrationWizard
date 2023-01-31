//
//  FriendRequest.swift
//  VibrationWizard
//
//  Created by Consultant on 1/28/23.
//

import Foundation
import FirebaseFirestore

struct TheFriendRequest: Codable
{
    let from: ID
    let to: ID
    let timeSent: Timestamp
    var accepted: NotificationStatus
    let friendRequestID: ID
    let type: String
}
