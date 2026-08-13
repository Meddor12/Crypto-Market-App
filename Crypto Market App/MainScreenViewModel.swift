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
    
    private let perPage = 50
    private(set) var currentPage = 1
    private(set) var isLoading = false
    private(set) var canLoadMore = true
    
    func makeCoinsMarketsURL(page: Int) -> URL? {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=\(perPage)&page=\(page)"
        return URL(string: urlString)
    }
    
    // reset — вызываем при pull-to-refresh
    func reset() {
        currentPage = 1
        canLoadMore = true
    }
    
    func fetchNextPage(completion: @escaping (ViewState) -> Void) {
        guard !isLoading, canLoadMore else { return }
        
        isLoading = true
        DispatchQueue.main.async { completion(.loading) }
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = self.makeCoinsMarketsURL(page: self.currentPage) else {
                self.isLoading = false
                DispatchQueue.main.async { completion(.error("Invalid URL")) }
                return
            }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self else { return }
                
                defer { self.isLoading = false }
                
                if let error = error {
                    DispatchQueue.main.async { completion(.error("Ошибка получения данных \(error)")) }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async { completion(.error("Данные отсутствуют")) }
                    return
                }
                
                do {
                    let coins = try JSONDecoder().decode([Coin].self, from: data)
                    
                    if coins.count < self.perPage {
                        self.canLoadMore = false
                    }
                    self.currentPage += 1
                    
                    DispatchQueue.main.async {
                        completion(.loaded(coins))
                    }
                } catch {
                    DispatchQueue.main.async { completion(.error("Ошибка декодирования данных \(error)")) }
                }
            }.resume()
        }
    }
}
