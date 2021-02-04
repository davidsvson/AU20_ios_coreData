//
//  CoreDataIntroApp.swift
//  CoreDataIntro
//
//  Created by David Svensson on 2021-02-04.
//

import SwiftUI

@main
struct CoreDataIntroApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
