//
//  ColorSlider.swift
//  SwiftUIDrawing
//
//  Created by Stefan Boblic on 02.02.2023.
//

import SwiftUI

struct ColorSlider: View {
    @Binding var sliderValue: Double
    var range: ClosedRange<Double> = 0...1
    var colors: [Color] = [.blue, .black, .white]

    var body: some View {
        let gradient = LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)

        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                gradient
                    .cornerRadius(5)
                    .frame(height: 10)
                SliderCircleView(
                    value: $sliderValue,
                    range: range,
                    sliderWidth: geometry.size.width
                )
            }
            .frame(width: geometry.size.width,
                   height: geometry.size.height,
                   alignment: .center)
        }
    }
}

struct ColorSlider_Previews: PreviewProvider {
    @State static var sliderValue: Double = 0
    static var previews: some View {
        ColorSlider(sliderValue: $sliderValue)
            .padding()
            .background(.secondary)
    }
}
extension ColorSlider {
    struct SliderCircleView: View {
        @State private var offset: CGSize = .zero

        @Binding var value: Double

        let range: ClosedRange<Double>
        let diameter: Double = 30
        let sliderWidth: Double

        var sliderValue: Double {
            let percent = Double(offset.width / (sliderWidth - diameter))
            let value = (range.upperBound - range.lowerBound) * percent + range.lowerBound
            return value
        }

        var body: some View {
            let drag = DragGesture()
                .onChanged {
                    offset.width = clampWidth(translation: $0.translation.width)
                    value = sliderValue
                }
            Circle()
                .foregroundColor(.white)
                .shadow(color: .gray, radius: 1)
                .frame(width: diameter, height: diameter)
                .gesture(drag)
                .offset(offset)
        }

        func clampWidth(translation: Double) -> Double {
          return min(sliderWidth - diameter, max(0, offset.width + translation))
        }
    }
}
