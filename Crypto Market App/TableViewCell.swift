//
//  TableViewCell.swift
//  Crypto Market App
//
//  Created by Shiddo on 12.08.2026.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "TableViewTest"
    
    private var imageCoin: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "btc")
        return view
    }()
    
    private var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "BTC"
        return label
    }()
    
    private var symbol: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "BTC"
        return label
    }()
    
    private var price: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "64 320 50"
        return label
    }()
    
    private var priceChange: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+ 1.24%"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addingSubviews() {
        contentView.addSubview(imageCoin)
        contentView.addSubview(name)
        contentView.addSubview(symbol)
        contentView.addSubview(price)
        contentView.addSubview(priceChange)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            imageCoin.topAnchor.constraint(equalTo: contentView.topAnchor, constant:  12),
            imageCoin.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant:  12),
            imageCoin.widthAnchor.constraint(equalToConstant: 54),
            imageCoin.heightAnchor.constraint(equalToConstant: 54),
            imageCoin.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            name.leftAnchor.constraint(equalTo: imageCoin.rightAnchor, constant: 12),
            
            symbol.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 12),
            symbol.leftAnchor.constraint(equalTo: imageCoin.rightAnchor, constant: 12),
            
            price.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            price.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            
            priceChange.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 12),
            priceChange.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12)
            
            
            
        ])
    }
    
    private func setupCell() {
        addingSubviews()
        setupConstraints()
    }
    
    func configure(model: Coin) {
        name.text = model.name
        symbol.text = model.symbol
        price.text = "\(model.currentPrice)"
        priceChange.text = "\(model.priceChangePercentage24h ?? 0)"
        
        priceChange.textColor = (model.priceChangePercentage24h ?? 0) >= 0 ? .systemGreen : .systemRed
    }
}
