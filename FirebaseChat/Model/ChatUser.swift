//
//  ChatUser.swift
//  FirebaseChat
//
//  Created by 庄司陽 on 2022/04/20.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatUser: Codable, Identifiable {
    
    @DocumentID var id: String?
    let uid, email, profileImageUrl: String
}
