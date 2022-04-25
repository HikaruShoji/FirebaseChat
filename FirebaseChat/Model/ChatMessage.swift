//
//  ChatMessage.swift
//  FirebaseChat
//
//  Created by 庄司陽 on 2022/04/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ChatMessage: Codable, Identifiable {
    
    @DocumentID var id: String?
    let fromId, toId, text: String
    let timestamp: Date
}
