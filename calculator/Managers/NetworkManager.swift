//
//  NetworkManager.swift
//  calculator
//
//  Created by Patrick Lawler on 11/2/22.
//

import Foundation

struct NetworkManager {
    
    static let shared   = NetworkManager()
    
    
    
    enum NetworkError: Error {
        case badURL
        case badNetwork
        case badResponse
        case badData
    }
    
    private init(){}
    
    func getRatesFromApi(baseCurrency: String, completed: @escaping (Result<RateData, NetworkError>) -> Void) {
        
        let baseURL = "https://openexchangerates.org/api/latest.json?app_id=731fb56b61af4e7ca81801d474689ab8&base="
        
        let endpoint = baseURL + "\(baseCurrency)"
    
        // verifies it's a good URL
        guard let url = URL(string: endpoint) else {
            completed(.failure(.badURL))
            return
        }
        
        // makes the url call and gets back a response, the json data and any errors
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // ensures no errors were were received
            if let _ = error {
                completed(.failure(.badNetwork))
                return
            }
            
            // ensures the response is not nil and that it is a 200 (OK)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.badResponse))
                return
            }
            
            // ensures the received json data is not nil
            guard let data = data else {
                completed(.failure(.badData))
                return
            }
            
            do {
                // creates a json decoder instance
                let decoder = JSONDecoder()
                
                // ensures the rates are decoded from the json data
                let rates = try decoder.decode(OpenExchangeRates.self, from: data)
                completed(.success(formatRateData(data: rates)))
                
            } catch {
                completed(.failure(.badData))
            }
            
        }
        
        task.resume()
        
    }
    
    private func formatRateData(data: OpenExchangeRates) -> RateData {
        
        // converts the data received into an object that has the rates in an array vs the json structure
        
        return RateData(timestamp: data.timestamp, base: data.base, rates: convertToDictionary(data.rates))
    }
    
    private func convertToDictionary(_ data: CurrencyCollection) -> [String : Double?] {
        
        // converts the recevied strutct into a dictionary array
        
        let rates = [
            "AED": data.AED,
            "ANG": data.ANG,
            "AUD": data.AUD,
            "AMD": data.AMD,
            "ARS": data.ARS,
            "AWG": data.AWG,
            "BAM": data.BAM,
            "BDT": data.BDT,
            "BHD": data.BHD,
            "BMD": data.BMD,
            "BOB": data.BOB,
            "BRL": data.BRL,
            "BSD": data.BSD,
            "BTC": data.BTC,
            "BZD": data.BZD,
            "CAD": data.CAD,
            "CDF": data.CDF,
            "CHF": data.CHF,
            "CLF": data.CLF,
            "CLP": data.CLP,
            "CNH": data.CNH,
            "CNY": data.CNY,
            "COP": data.COP,
            "CRC": data.CRC,
            "CUC": data.CUC,
            "CUP": data.CUP,
            "CZK": data.CZK,
            "DJF": data.DJF,
            "DKK": data.DKK,
            "DOP": data.DOP,
            "DZD": data.DZD,
            "EGP": data.EGP,
            "EUR": data.EUR,
            "GTQ": data.GTQ,
            "AFN": data.AFN,
            "ALL": data.ALL,
            "AOA": data.AOA,
            "AZN": data.AZN,
            "BBD": data.BBD,
            "BGN": data.BGN,
            "BIF": data.BIF,
            "BND": data.BND,
            "BTN": data.BTN,
            "BWP": data.BWP,
            "BYN": data.BYN,
            "CVE": data.CVE,
            "ERN": data.ERN,
            "ETB": data.ETB,
            "FJD": data.FJD,
            "FKP": data.FKP,
            "GBP": data.GBP,
            "GEL": data.GEL,
            "GGP": data.GGP,
            "GHS": data.GHS,
            "GIP": data.GIP,
            "GMD": data.GMD,
            "GNF": data.GNF,
            "GYD": data.GYD,
            "HKD": data.HKD,
            "HNL": data.HNL,
            "HRK": data.HRK,
            "HTG": data.HTG,
            "HUF": data.HUF,
            "IDR": data.IDR,
            "ILS": data.ILS,
            "IMP": data.IMP,
            "INR": data.INR,
            "IQD": data.IQD,
            "IRR": data.IRR,
            "ISK": data.ISK,
            "JEP": data.JEP,
            "JMD": data.JMD,
            "JOD": data.JOD,
            "JPY": data.JPY,
            "KES": data.KES,
            "KGS": data.KGS,
            "KHR": data.KHR,
            "KMF": data.KMF,
            "KPW": data.KPW,
            "KRW": data.KRW,
            "KWD": data.KWD,
            "KYD": data.KYD,
            "KZT": data.KZT,
            "LAK": data.LAK,
            "LBP": data.LBP,
            "LKR": data.LKR,
            "LRD": data.LRD,
            "LSL": data.LSL,
            "LYD": data.LYD,
            "MAD": data.MAD,
            "MDL": data.MDL,
            "MGA": data.MGA,
            "MKD": data.MKD,
            "MMK": data.MMK,
            "MNT": data.MNT,
            "MOP": data.MOP,
            "MRO": data.MRO,
            "MRU": data.MRU,
            "MUR": data.MUR,
            "MVR": data.MVR,
            "MWK": data.MWK,
            "MXN": data.MXN,
            "MYR": data.MYR,
            "MZN": data.MZN,
            "NAD": data.NAD,
            "NGN": data.NGN,
            "NIO": data.NIO,
            "NOK": data.NOK,
            "NPR": data.NPR,
            "NZD": data.NZD,
            "OMR": data.OMR,
            "PAB": data.PAB,
            "PEN": data.PEN,
            "PGK": data.PGK,
            "PHP": data.PHP,
            "PKR": data.PKR,
            "PLN": data.PLN,
            "PYG": data.PYG,
            "QAR": data.QAR,
            "RON": data.RON,
            "RSD": data.RSD,
            "RUB": data.RUB,
            "RWF": data.RWF,
            "SAR": data.SAR,
            "SBD": data.SBD,
            "SCR": data.SCR,
            "SDG": data.SDG,
            "SEK": data.SEK,
            "SGD": data.SGD,
            "SHP": data.SHP,
            "SLL": data.SLL,
            "SOS": data.SOS,
            "SRD": data.SRD,
            "SSP": data.SSP,
            "STD": data.STD,
            "STN": data.STN,
            "SVC": data.SVC,
            "SYP": data.SYP,
            "SZL": data.SZL,
            "THB": data.THB,
            "TJS": data.TJS,
            "TMT": data.TMT,
            "TND": data.TND,
            "TOP": data.TOP,
            "TRY": data.TRY,
            "TTD": data.TTD,
            "TWD": data.TWD,
            "TZS": data.TZS,
            "UAH": data.UAH,
            "UGX": data.UGX,
            "USD": data.USD,
            "UYU": data.UYU,
            "UZS": data.UZS,
            "VEF": data.VEF,
            "VES": data.VES,
            "VND": data.VND,
            "VUV": data.VUV,
            "WST": data.WST,
            "XAF": data.XAF,
            "XAG": data.XAG,
            "XAU": data.XAU,
            "XCD": data.XCD,
            "XDR": data.XDR,
            "XOF": data.XOF,
            "XPD": data.XPD,
            "XPF": data.XPF,
            "XPT": data.XPT,
            "YER": data.YER,
            "ZAR": data.ZAR,
            "ZMW": data.ZMW,
            "ZWL": data.ZWL,
        ]
        return rates
    }
}
