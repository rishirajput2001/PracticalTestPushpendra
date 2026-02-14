//
//  UserListDemoApp.swift
//  UserListDemo
//
//  Created by Mac on 14/02/26.
//

import SwiftUI
import CoreData

@main
struct UserListDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(context: persistenceController.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
