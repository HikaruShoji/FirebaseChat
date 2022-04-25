//
//  FirebaseChatApp.swift
//  FirebaseChat
//
//  Created by 庄司陽 on 2022/04/22.
//

import SwiftUI

@main
struct FirebaseChatApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            LoginView()
            MainMessagesView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
