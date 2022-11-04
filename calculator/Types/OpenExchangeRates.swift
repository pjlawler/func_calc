//
//  ExchangeRateData.swift
//  calculator
//
//  Created by Patrick Lawler on 11/2/22.
//

import Foundation

struct OpenExchangeRates: Codable {
    var timestamp: Int
    var base: String
    var rates: CurrencyCollection
}
