//
//  DrawingPadView.swift
//  SwiftUIDrawing
//
//  Created by Stefan Boblic on 03.02.2023.
//

import SwiftUI

struct DrawingPadView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var cellStore: CellStore

    @State var drawing: UIImage?
    @State private var pickedColor = ColorPicker.Color.black

    var body: some View {
        VStack {
            HStack {
                Button("Cancel") { dismiss() }
                Spacer()
                Button("Save") {
                    if let cell = cellStore.selectedCell,
                       let drawing = drawing {
                        cellStore.updateDrawing(cell: cell, drawing: drawing)
                    }
                    dismiss()
                }
            }
            .padding()

            Divider()

            DrawingPadRepresentation(drawingImage: $drawing, color: pickedColor.uiColor)

            Divider()

            ColorPicker(pickedColor: $pickedColor)
                .frame(height: 80)
        }
    }
}

struct DrawingPadView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingPadView()
            .environmentObject(CellStore())
    }
}

