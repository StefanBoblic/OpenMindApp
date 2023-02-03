//
//  FlyoutMenu.swift
//  SwiftUIDrawing
//
//  Created by Stefan Boblic on 03.02.2023.
//

import SwiftUI
import Algorithms

struct FlyoutMenu: View {
    struct Option {
        var image: Image
        var color: Color
        var action: () -> Void = {}
    }

    let iconDiameter: Double = 44
    let menuDiameter: Double = 150
    let options: [FlyoutMenu.Option]
    @State private var isOpen = false

    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.pink).opacity(0.1)
                .frame(width: isOpen ? menuDiameter : 0)
            ForEach(options.indexed(), id: \.index) { index, option in
                button(option: option, atIndex: index)
                    .scaleEffect(isOpen ? 1 : 0.1)
            }
            .disabled(!isOpen)
            MainView(iconDiameter: iconDiameter, isOpen: $isOpen)
        }
    }

    private func button(option: Option, atIndex index: Int) -> some View {
        let angle = .pi / 4 * Double(index) - .pi * (isOpen ? 0.6 : 1)
        let radius = menuDiameter / 2

       return Button(action: option.action) {
            ZStack {
                Circle()
                    .foregroundColor(option.color)
                    .frame(width: iconDiameter, height: iconDiameter)
                option.image
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .offset(x: cos(angle) * radius, y: sin(angle) * radius)
    }
}

extension FlyoutMenu {
    struct MainView: View {
        let iconDiameter: Double
        @Binding var isOpen: Bool

        var body: some View {
            Button {
                withAnimation {
                    isOpen.toggle()
                }
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(.red)
                    .frame(width: iconDiameter, height: iconDiameter)
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.title)
                        .rotationEffect(isOpen ? .degrees(45) : .degrees(0))
                }
            }

        }
    }
}

struct FlyoutMenu_Previews: PreviewProvider {
    static var options: [FlyoutMenu.Option] = [
        .init(image: .init(systemName: "trash"), color: .blue),
        .init(image: .init(systemName: "pawprint"), color: .orange),
        .init(image: .init(systemName: "book"), color: .teal),
        .init(image: .init(systemName: "flame"), color: .red),
        .init(image: .init(systemName: "link"), color: .purple)
    ]
    static var previews: some View {
        FlyoutMenu(options: options)
    }
}
