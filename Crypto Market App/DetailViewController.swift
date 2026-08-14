//
//  DetailViewController.swift
//  Crypto Market App
//
//  Created by Shiddo on 13.08.2026.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    
    private let coin: Coin
    let backroundView = LabelBackgroundView()
    
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
    
    private lazy var saveButton: UIButton = {
          let button = UIButton(type: .system)
          button.translatesAutoresizingMaskIntoConstraints = false
          button.setTitle("Сохранить в избранное", for: .normal)
          button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
          button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
          return button
      }()
    
    private var context: NSManagedObjectContext {
           (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       }
    
    init(coin: Coin) {
        self.coin = coin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstrates()
        
        ImageLoader.shared.loadImage(from: coin.image) { [weak self] image in
            self?.imageCoin.image = image
        }
        name.text = coin.name
        symbol.text = coin.symbol
        price.text = "$ \(coin.currentPrice)"
        priceChange.text = "\(coin.priceChangePercentage24h, default: "")"
        priceChange.textColor = (coin.priceChangePercentage24h ?? 0) >= 0 ? .systemGreen : .systemRed

        backroundView.set(titleText: "$\(coin.marketCap?.abbreviated, default: "")")
    }
    @objc private func saveTapped() {
            let cdCoin = CDCoins(context: context)
            cdCoin.id = coin.id
            cdCoin.symbol = coin.symbol
            cdCoin.name = coin.name
            cdCoin.image = coin.image
            cdCoin.price = "\(coin.currentPrice)"
            cdCoin.marketCap = coin.marketCap.map { "\($0)" }
            cdCoin.price_change_percentage_24h = coin.priceChangePercentage24h.map { "\($0)" }
            
            do {
                try context.save()
                showSavedFeedback()
            } catch {
                print("Ошибка сохранения: \(error)")
            }
        }
    private func showSavedFeedback() {
            let alert = UIAlertController(title: nil, message: "Сохранено в избранное", preferredStyle: .alert)
            present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                alert.dismiss(animated: true)
            }
        }
    
    func setupConstrates() {
        view.addSubview(imageCoin)
        view.addSubview(name)
        view.addSubview(symbol)
        view.addSubview(price)
        view.addSubview(priceChange)
        view.addSubview(backroundView)
        view.addSubview(saveButton)
        
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
            
            backroundView.topAnchor.constraint(equalTo: priceChange.bottomAnchor, constant: 64),
            backroundView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            backroundView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            backroundView.heightAnchor.constraint(equalToConstant: 100),
            
            saveButton.topAnchor.constraint(equalTo: backroundView.bottomAnchor, constant: 32),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
    }
}
