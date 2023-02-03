//
//  BackgroundView.swift
//  SwiftUIDrawing
//
//  Created by Stefan Boblic on 02.02.2023.
//

import SwiftUI

struct BackgroundView: View {
  @EnvironmentObject var cellStore: CellStore
  let size: CGSize

  var body: some View {
    let doubleTapDrag = DragGesture(minimumDistance: 0)
    let doubleTap = TapGesture(count: 2)
      .sequenced(before: doubleTapDrag)
      .onEnded { value in
        switch value {
        case .second(_, let drag):
          if let drag = drag {
            print("add new cell at: ", drag.location)
            newCell(location: drag.location)
          }
        default: break
        }
      }

    ZStack {
     GridView()
        .ignoresSafeArea()
        .onTapGesture { cellStore.selectedCell = nil }
        .simultaneousGesture(doubleTap)

      ForEach(cellStore.cells) { cell in
        CellView(cell: cell)
      }
    }
  }

  func newCell(location: CGPoint) {
    let offset = CGSize(
      width: location.x - size.width / 2,
      height: location.y - size.height / 2
    )
    let cell = cellStore.addCell(offset: offset)
    cellStore.selectedCell = cell
  }
}

struct BackgroundView_Previews: PreviewProvider {
  static var previews: some View {
    BackgroundView(size: CGSize(width: 400, height: 800))
      .environmentObject(CellStore())
  }
}
