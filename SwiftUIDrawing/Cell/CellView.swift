//
//  CellView.swift
//  SwiftUIDrawing
//
//  Created by Stefan Boblic on 02.02.2023.
//

import SwiftUI

struct CellView: View {
    let cell: Cell
    @EnvironmentObject var cellStore: CellStore
    @EnvironmentObject var modalViews: ContentView.ModalViews

    @FocusState var textFieldIsFocused: Bool

    @State private var text: String = ""
    @State private var offset: CGSize = .zero
    @State private var currentOffset: CGSize = .zero

    var isSelected: Bool {
        cell == cellStore.selectedCell
    }

    var body: some View {
        let flyoutMenu = FlyoutMenu(options: setupOptions())
        let drag = DragGesture()
            .onChanged { drag in
                offset = currentOffset + drag.translation
            }
            .onEnded { drag in
                offset = currentOffset + drag.translation
                currentOffset = offset
            }
        ZStack {
            ZStack {
                cell.shape.shape
                    .foregroundColor(Color(uiColor: .systemBackground))
                TimelineView(.animation(minimumInterval: 0.1)) { context in
                    StrokeView(cell: cell, isSelected: isSelected, date: context.date)
                }
                if let drawing = cell.drawing {
                    DrawingView(drawing: drawing, size: cell.size)
                        .scaleEffect(0.8)
                } else {
                    TextField("Enter cell text", text: $text)
                        .padding()
                        .multilineTextAlignment(.center)
                        .focused($textFieldIsFocused)
                }
            }
            .frame(width: cell.size.width, height: cell.size.height)

            if isSelected {
                flyoutMenu
                    .offset(x: cell.size.width / 2, y: -cell.size.height / 2)
            }
        }
        .onAppear { text = cell.text }
        .onChange(of: isSelected) { isSelected in
            if !isSelected { textFieldIsFocused = false }

        }
        .offset(cell.offset + offset)
        .onTapGesture {
            cellStore.selectedCell = cell
        }
        .simultaneousGesture(drag)
    }
}

extension CellView {
    struct StrokeView: View {
        let cell: Cell
        let isSelected: Bool
        let date: Date
        @State private var dashPhase: Double = 0

        var body: some View {
            let basicStyle = StrokeStyle(lineWidth: 5, lineJoin: .round)
            let selectedStyle = StrokeStyle(lineWidth: 7, lineCap: .round, lineJoin: .round, dash: [50, 15, 30, 15, 15, 15, 5, 10, 5, 15], dashPhase: dashPhase)
            cell.shape.shape
                .stroke(cell.color.opacity(isSelected ? 0.8 : 1), style: isSelected ? selectedStyle : basicStyle)
                .onChange(of: date, perform: { _ in
                    dashPhase += 6
                })
        }
    }
}

extension CellView {
    func setupOptions() -> [FlyoutMenu.Option] {
        let options: [FlyoutMenu.Option] = [
            .init(image: Image(systemName: "trash"), color: .blue) {
                cellStore.delete(cell: cell)
            },
            .init(image: Image(systemName: "square.on.circle"), color: .green) {
                modalViews.showShapes = true
            },
            .init(image: Image(systemName: "link"), color: .purple) {

            },
            .init(image: Image("crayon"), color: .orange) {
                modalViews.showDrawingPad = true
            }
        ]
        return options
    }
}

extension CellView {
    struct DrawingView: View {
        let drawing: Drawing
        let size: CGSize

        var body: some View {
            let scaleFactor = drawing.size.scaleFactor(toFit: size)
            
            Canvas { context, size in
                context.scaleBy(x: scaleFactor, y: scaleFactor)
                for path in drawing.paths {
                    let style = StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                    context.stroke(path.path, with: .color(path.color), style: style)
                }
            }
            .aspectRatio(drawing.size, contentMode: .fit)
        }
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(cell: Cell())
            .previewLayout(.sizeThatFits)
            .padding()
            .environmentObject(CellStore())
    }
}
