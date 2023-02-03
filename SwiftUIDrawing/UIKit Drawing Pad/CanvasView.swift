//
//  CanvasView.swift
//  SwiftUIDrawing
//
//  Created by Stefan Boblic on 03.02.2023.
//

import UIKit

class CanvasView: UIControl {
    var drawingImage: UIImage?
    var color: UIColor = .black

    private let defaulLineWidth: CGFloat = 6
    private let minLineWidth: CGFloat = 5
    private let forceSensitivity: CGFloat = 4
    private let drawingColorView = DrawingColorView()

    init(color: UIColor, drawingImage: UIImage?) {
        self.drawingImage = drawingImage
        self.color = color
        super.init(frame: .zero)

        addSubview(drawingColorView)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        addGestureRecognizer(longPress)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        drawingImage?.draw(in: rect)
    }

    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard let drawingImage = drawingImage else { return }
        let location = gesture.location(in: self)
        guard let color = drawingImage.getColor(at: location) else { return }

        switch gesture.state {
        case .began:
            drawingColorView.show(color: color, location: location)
        case .ended:
            drawingColorView.hide()
            self.color = color
        default:
            break
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendActions(for: .valueChanged)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        drawingImage = UIGraphicsImageRenderer(size: bounds.size).image { context in
            UIColor.white.setFill()
            context.fill(bounds)
            drawingImage?.draw(in: bounds)

            var touches: [UITouch] = []
            if let coalescedTouches = event?.coalescedTouches(for: touch) {
                touches = coalescedTouches
            } else {
                touches.append(touch)
            }
            for touch in touches {
                drawStroke(context: context.cgContext, touch: touch)
            }
        }
        setNeedsDisplay()
    }

    private func drawStroke(context: CGContext, touch: UITouch) {
        let previousLocation = touch.previousLocation(in: self)
        let location = touch.location(in: self)

        var lineWidth: CGFloat = defaulLineWidth
        if touch.force > 0 {
            lineWidth = touch.force * forceSensitivity
        }
        context.setLineWidth(lineWidth)
        context.setLineCap(.round)
        color.setStroke()

        context.move(to: previousLocation)
        context.addLine(to: location)
        context.strokePath()
    }
}
