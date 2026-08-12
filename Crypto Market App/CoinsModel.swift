//
//  CoinsModel.swift
//  Crypto Market App
//
//  Created by Shiddo on 12.08.2026.
//

import Foundation

struct Coin: Codable, Identifiable {
    var id: String
    var symbol: String
    var name: String
    var image: String
    var currentPrice: Double
    var marketCap: Double?
    var marketCapRank: Int?
    var priceChangePercentage24h: Double?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case priceChangePercentage24h = "price_change_percentage_24h"
    }
}
