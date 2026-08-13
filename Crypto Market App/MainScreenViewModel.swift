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
    
    private let perPage = 100
    private(set) var currentPage = 1
    private(set) var isLoading = false
    private(set) var canLoadMore = true
    private var currentTask: URLSessionDataTask?
    
    func makeCoinsMarketsURL(page: Int) -> URL? {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=\(perPage)&page=\(page)"
        return URL(string: urlString)
    }
    
    func reset() {
        currentTask?.cancel()   // отменяем "зависший" старый запрос
        currentTask = nil
        isLoading = false
        currentPage = 1
        canLoadMore = true
    }
    
    func fetchNextPage(completion: @escaping (ViewState) -> Void) {
        guard !isLoading, canLoadMore else { return }
        
        isLoading = true
        completion(.loading)
        
        guard let url = makeCoinsMarketsURL(page: currentPage) else {
            isLoading = false
            completion(.error("Invalid URL"))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // сразу прыгаем на главный поток — ВСЯ работа с state и completion только тут
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false
                
                if let error = error {
                    // если это отмена (reset вызвал cancel) — просто выходим молча
                    if (error as NSError).code == NSURLErrorCancelled { return }
                    completion(.error("Ошибка получения данных \(error)"))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse,
                   !(200...299).contains(httpResponse.statusCode) {
                    completion(.error("Сервер вернул код \(httpResponse.statusCode) — похоже на rate limit"))
                    return
                }
                
                guard let data = data else {
                    completion(.error("Данные отсутствуют"))
                    return
                }
                
                do {
                    let coins = try JSONDecoder().decode([Coin].self, from: data)
                    if coins.count < self.perPage {
                        self.canLoadMore = false
                    }
                    self.currentPage += 1
                    completion(.loaded(coins))
                } catch {
                    completion(.error("Ошибка декодирования данных \(error)"))
                }
            }
        }
        
        currentTask = task
        task.resume()
    }
}
