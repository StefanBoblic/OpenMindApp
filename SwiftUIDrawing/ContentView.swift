//
//  ContentView.swift
//  SwiftUIDrawing
//
//  Created by Stefan Boblic on 01.02.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var cellStore: CellStore
    @EnvironmentObject var modalViews: ContentView.ModalViews

    @State private var cellShape = CellShape.roundedRect

    var body: some View {
        GeometryReader { geonetryProxy in
            BackgroundView(size: geonetryProxy.size)
        }
        .onChange(of: cellShape, perform: { newValue in
            guard let cell = cellStore.selectedCell else { return }
            cellStore.updateShape(cell: cell, shape: newValue)
        })
        .sheet(isPresented: $modalViews.showShapes) {
            ShapeSelectionGrid(selectedCellShape: $cellShape)
        }
        .fullScreenCover(isPresented: $modalViews.showDrawingPad) {
            DrawingPadView()
        }
    }
}

extension ContentView {
    class ModalViews: ObservableObject {
        @Published var showShapes = false
        @Published var showDrawingPad = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CellStore())
            .environmentObject(ContentView.ModalViews())
    }
}
