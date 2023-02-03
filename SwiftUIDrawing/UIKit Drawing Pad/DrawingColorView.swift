//
//  DrawingColorView.swift
//  SwiftUIDrawing
//
//  Created by Stefan Boblic on 03.02.2023.
//

import UIKit

class DrawingColorView: UIView {

    var color: UIColor = .black

    init() {
        let frame = CGRect(origin: .zero, size: CGSize(width: 50, height: 50))
        super.init(frame: frame)
        isHidden = true
        layer.cornerRadius = frame.width / 2
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 4
        layer.shadowRadius = 5
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.5
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(color: UIColor, location: CGPoint) {
        frame.origin.x = location.x - bounds.midX
        frame.origin.y = location.y - bounds.height
        backgroundColor = color
        isHidden = false
    }

    func hide() {
        isHidden = true
    }
}

