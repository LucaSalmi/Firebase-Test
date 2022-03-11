//
//  Firebase_TestApp.swift
//  Firebase Test
//
//  Created by Luca Salmi on 2022-03-11.
//

import SwiftUI
import Firebase

@main
struct Firebase_TestApp: App {
    
    init(){
        
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
