//
//  ShapeSelectionGrid.swift
//  SwiftUIDrawing
//
//  Created by Stefan Boblic on 02.02.2023.
//

import SwiftUI

struct AnyShape: Shape {
    private let path: (CGRect) -> Path

    init<T: Shape> (_ shape: T) {
        path = { rect in
            return shape.path(in: rect)
        }
    }

    func path(in rect: CGRect) -> Path {
        path(rect)
    }
}

extension Shape {
    func anyShape() -> AnyShape {
        AnyShape(self)
    }
}

enum CellShape: CaseIterable {
    case rectangle
    case ellipse
    case diamond
    case chevron
    case heart
    case roundedRect

    var shape: some Shape {
        switch self {
        case .rectangle: return Rectangle().anyShape()
        case .ellipse: return Ellipse().anyShape()
        case .chevron: return Chevron().anyShape()
        case .diamond: return Diamond().anyShape()
        case .heart: return Heart().anyShape()
        case .roundedRect: return RoundedRectangle(cornerRadius: 30).anyShape()
        }
    }
}

struct ShapeSelectionGrid: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCellShape: CellShape

    var body: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
        let style = StrokeStyle(lineWidth: 5, lineJoin: .round)

        LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
            ForEach(CellShape.allCases, id: \.self) { cellShape in
                cellShape.shape
                    .foregroundColor(.accentColor.opacity(0.3))
                    .overlay {
                        cellShape.shape
                            .stroke(style: style)
                            .foregroundColor(.accentColor)
                    }
                    .onTapGesture {
                        selectedCellShape = cellShape
                        dismiss()
                    }
            }
            .aspectRatio(2, contentMode: .fit)
            .padding()
        }
    }
}

struct Chevron: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addLines([
                .zero,
                CGPoint(x: rect.width * 0.75, y: 0),
                CGPoint(x: rect.width, y: rect.height * 0.5),
                CGPoint(x: rect.width * 0.75, y: rect.height),
                CGPoint(x: 0, y: rect.height),
                CGPoint(x: rect.width * 0.25, y: rect.height * 0.5)
            ])
            path.closeSubpath()
        }
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height

            path.addLines( [
                CGPoint(x: width / 2, y: 0),
                CGPoint(x: width, y: height / 2),
                CGPoint(x: width / 2, y: height),
                CGPoint(x: 0, y: height / 2)
            ])
            path.closeSubpath()
        }
    }
}

struct Heart: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let flip = CGAffineTransform(translationX: rect.width, y: 0)
            .scaledBy(x: -1, y: 1)

        let bottom = CGPoint(x: rect.width * 0.5, y: rect.height)
        let leftSide = CGPoint(x: 0, y: rect.height * 0.25)
        let leftTop = CGPoint(x: rect.width * 0.25, y: 0)
        let midTop = CGPoint(x: rect.width * 0.5, y: rect.height * 0.25)

        let rightSide = leftSide.applying(flip)
        let rightTop = leftTop.applying(flip)

        let sideControl = CGPoint(x: 0, y: rect.height * 0.75)
        let cornerControl = CGPoint.zero
        let midControl = CGPoint(x: rect.width * 0.5, y: 0)

        path.move(to: bottom)
        path.addCurve(to: leftSide, control1: bottom, control2: sideControl)
        path.addCurve(to: leftTop, control1: leftSide, control2: cornerControl)
        path.addCurve(to: midTop, control1: midControl, control2: midTop)
        path.addCurve(to: rightTop, control1: midTop, control2: midControl)
        path.addCurve(to: rightSide, control1: cornerControl.applying(flip), control2: rightSide)
        path.addCurve(to: bottom, control1: sideControl.applying(flip), control2: bottom)

        path.closeSubpath()
        return path
    }
}

struct Shapes_Previews: PreviewProvider {
    static var previews: some View {
        ShapeSelectionGrid(selectedCellShape: .constant(.heart))
    }
}
