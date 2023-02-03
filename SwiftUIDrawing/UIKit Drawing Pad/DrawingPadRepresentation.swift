//
//  DrawingPadRepresentation.swift
//  SwiftUIDrawing
//
//  Created by Stefan Boblic on 03.02.2023.
//

import SwiftUI

struct DrawingPadRepresentation: UIViewRepresentable {
    @Binding var drawingImage: UIImage?
    let color: UIColor

    func makeUIView(context: Context) -> CanvasView {
        let view = CanvasView(color: color, drawingImage: drawingImage)
        view.addTarget(context.coordinator, action: #selector(Coordinator.drawingImageChanged), for: .valueChanged)
        return view
    }

    func updateUIView(_ uiView: CanvasView, context: Context) {
        uiView.color = color
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(drawingImage: $drawingImage)
    }
}

extension DrawingPadRepresentation {
    class Coordinator: NSObject {
        @Binding var drawingImage: UIImage?

        init(drawingImage: Binding<UIImage?>) {
            _drawingImage = drawingImage
        }

        @objc func drawingImageChanged(_ sender: CanvasView) {
            self.drawingImage = sender.drawingImage
        }
    }
}
