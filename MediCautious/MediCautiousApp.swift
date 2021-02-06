//
//  MediCautiousApp.swift
//  MediCautious
//
//  Created by Satvik Anand on 2/5/21.
//

import SwiftUI

@main
struct MediCautiousApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
