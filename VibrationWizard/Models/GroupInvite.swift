//
//  GroupInvite.swift
//  VibrationWizard
//
//  Created by Consultant on 1/29/23.
//

import Foundation
import FirebaseFirestore

struct TheGroupInvite: Codable
{
    let founder: ID
    let to: ID
    let timeSent: Timestamp
    var accepted: NotificationStatus
    let groupID: ID
    let type: String
    
}
