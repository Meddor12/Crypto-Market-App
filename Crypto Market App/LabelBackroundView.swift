//
//  LabelBackroundView.swift
//  Crypto Market App
//
//  Created by Shiddo on 13.08.2026.
//

import UIKit

class LabelBackgroundView: UIView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Рыночная капитализация"
        return label
    }()
    
    private var priceChange: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2.35"
        label.textAlignment = .center

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .gray
        layer.cornerRadius = 10
        
        addSubview(label)
        addSubview(priceChange)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            priceChange.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            priceChange.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            priceChange.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            priceChange.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func set(titleText: String) {
        self.priceChange.text = titleText
       

    }
}

