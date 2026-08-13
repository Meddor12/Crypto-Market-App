//
//  DetailViewController.swift
//  Crypto Market App
//
//  Created by Shiddo on 13.08.2026.
//

import UIKit

class DetailViewController: UIViewController {
    
    private var imageCoin: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "photo.artframe.circle.fill")
        view.layer.cornerRadius = 27
        view.clipsToBounds = true
        
        return view
    }()
    
    private var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "BTC"
        label.textAlignment = .center
        return label
    }()
    
    private var symbol: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "btc"
        label.textAlignment = .center

        return label
    }()
    
    private var price: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "34 344 44"
        label.textAlignment = .center

        return label
    }()
    
    private var priceChange: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2.35"
        label.textAlignment = .center

        return label
    }()
    
    private var marketCup: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2.35"
        label.textAlignment = .center

        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        
        setupConstrates()
        
    }
    
    func setupConstrates() {
        view.addSubview(imageCoin)
        view.addSubview(name)
        view.addSubview(symbol)
        view.addSubview(price)
        view.addSubview(priceChange)
        view.addSubview(marketCup)
        
        NSLayoutConstraint.activate([
            imageCoin.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageCoin.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageCoin.widthAnchor.constraint(equalToConstant: 130),
            imageCoin.heightAnchor.constraint(equalToConstant: 130),
            
            name.topAnchor.constraint(equalTo: imageCoin.bottomAnchor, constant: 32),
            name.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            name.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            name.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            symbol.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 16),
            symbol.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            symbol.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            symbol.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            price.topAnchor.constraint(equalTo: symbol.bottomAnchor, constant: 32),
            price.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            price.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            price.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            priceChange.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 16),
            priceChange.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            priceChange.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            priceChange.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            marketCup.topAnchor.constraint(equalTo: priceChange.bottomAnchor, constant: 64),
            marketCup.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            marketCup.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            marketCup.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
        ])
    }
}
