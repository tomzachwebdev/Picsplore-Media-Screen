//
//  Picsplore_Media_Selection_ScreenApp.swift
//  Picsplore Media Selection Screen
//
//  Created by 123456 on 12/26/21.
//

import SwiftUI

@main
struct Picsplore_Media_Selection_ScreenApp: App {
    
    @StateObject var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
