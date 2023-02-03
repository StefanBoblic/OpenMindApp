//
//  ColorPicker.swift
//  SwiftUIDrawing
//
//  Created by Stefan Boblic on 02.02.2023.
//

import SwiftUI

struct ColorPickerView: View {
    @State var pickedColor: ColorPicker.Color = .red

    var body: some View {
        VStack {
            Circle()
                .foregroundColor(pickedColor.color)
                .frame(width: 250)
            ColorPicker(pickedColor: $pickedColor)
        }
    }
}

struct ColorPicker: View {
    let diameter: Double = 40
    @Binding var pickedColor: Color

    var body: some View {
        HStack {
            ForEach(Color.allCases, id: \.self) { color in
                ZStack {
                    Circle()
                        .foregroundColor(color.color)
                        .frame(width: diameter, height: diameter)
                        .onTapGesture { pickedColor = color }
                    Circle()
                        .foregroundColor(SwiftUI.Color(uiColor: UIColor.systemBackground))
                        .frame(width: pickedColor == color ? diameter * 0.25 : 0)
                }
            }
        }
        .frame(height: diameter * 3)
    }
}

extension ColorPicker {
    enum Color: CaseIterable {
        case black, violet, blue, green, yellow, orange, red

        var color: SwiftUI.Color {
            SwiftUI.Color(uiColor)
        }
        var uiColor: UIColor {
            switch self {
            case .black:
                return UIColor(named: "Black")!
            case .violet:
                return UIColor(named: "Violet")!
            case .blue:
                return UIColor(named: "Blue")!
            case .green:
                return UIColor(named: "Green")!
            case .yellow:
                return UIColor(named: "Yellow")!
            case .orange:
                return UIColor(named: "Orange")!
            case .red:
                return UIColor(named: "Red")!
            }
        }
    }
}

struct ColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView()
            .preferredColorScheme(.dark)
    }
}
