//
//  MainScreenVIewModel.swift
//  Crypto Market App
//
//  Created by Shiddo on 12.08.2026.
//

import Foundation

enum ViewState {
    case idle
    case loading
    case loaded([Coin])
    case error(String)
}


class MainScreenViewModel {
    
    func makeCoinsMarketsURL() -> URL? {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc"
        return URL(string: urlString)
    }
    
    private(set) var itemCount: Int = 0
    
    func fetchData(completion: @escaping (ViewState) -> Void) {
        DispatchQueue.main.async { completion(.loading) }
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = self.makeCoinsMarketsURL() else {
                print("Invalid URL")
                DispatchQueue.main.async { completion(.error("Invalid URL")) }
                return
            }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self else {
                    DispatchQueue.main.async { completion(.error("Нет объекта для загрузки")) }
                    return
                }
                
                if let error = error {
                    print("Ошибка получения данные \(error)")
                    
                    DispatchQueue.main.async { completion(.error("Ошибка получения данные \(error)")) }
                    
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async { completion(.error("Данные отсутсвуют")) }
                    return
                }
                
                do {
                    let coins = try JSONDecoder().decode([Coin].self, from: data)
                    
                    //print("Данные получены успешно")
                    
                    DispatchQueue.main.async {
                        self.itemCount = coins.count
                        print("Coins loaded: \(coins.count)")
                        completion(.loaded(coins))
                    }
                    
                    return
                    
                } catch {
                    print("Ошибка декодирования данных \(error)")
                    
                    DispatchQueue.main.async { completion(.error("Ошибка получения данные \(error)")) }
                }
            }.resume()
        }
    }
}
