//
//  SwiftUIDrawingApp.swift
//  SwiftUIDrawing
//
//  Created by Stefan Boblic on 01.02.2023.
//

import SwiftUI

@main
struct SwiftUIDrawingApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(CellStore())
                .environmentObject(ContentView.ModalViews())
        }
    }
}
