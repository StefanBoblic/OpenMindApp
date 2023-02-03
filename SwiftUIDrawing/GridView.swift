//
//  GridView.swift
//  SwiftUIDrawing
//
//  Created by Stefan Boblic on 03.02.2023.
//

import SwiftUI

struct GridView: View {
    var body: some View {
        let size = CGSize(width: 30, height: 30)
        let image = Image(uiImage: gridImage(size: size))

        ZStack {
            Color(uiColor: .tertiarySystemBackground)
            Rectangle()
                .fill(ImagePaint(image: image))
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }

    func gridImage(size: CGSize) -> UIImage {
        let width = size.width
        let height = size.height
        return UIGraphicsImageRenderer(size: size).image { context in
            UIColor.systemTeal.setStroke()

            let path = UIBezierPath()
            path.move(to: CGPoint(x: width, y: 0))
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.stroke()
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
    }
}
