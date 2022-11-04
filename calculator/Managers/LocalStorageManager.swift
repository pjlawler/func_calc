//
//  LocalStorageManager.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/4/22.
//

import Foundation

struct LocalStorageManager {
    
    static let shared = LocalStorageManager()
    
    private init(){}
    
    enum LocalStorageError: Error {
        case no_data
        case data_error
        case parsing_error
    }

    let rateDataKey = "rates"
        
    func retrieveRateData(completed: @escaping (Result<RateData, LocalStorageError>) -> Void){
        
        do {
            if let _ = UserDefaults.standard.object(forKey: rateDataKey) {
                
                let json = UserDefaults.standard.string(forKey: rateDataKey) ?? "{}"
                
                let jsonDecoder = JSONDecoder()
                
                guard let data = json.data(using: .utf8) else {
                    completed(.failure(.data_error))
                    return
                }
                
                let rateData: RateData = try jsonDecoder.decode(RateData.self, from: data)
                completed(.success(rateData))
                
            } else {
                completed(.failure(.no_data))
            }
            
        } catch {
            completed(.failure(.parsing_error))
        }
        
    }
    
    
    func saveExchangeRates(_ rateData: RateData) -> Bool {
        
        do {
            let jsonEncoder = JSONEncoder()
            
            let jsonData = try jsonEncoder.encode(rateData)
            
            let data = String(data: jsonData, encoding: .utf8) ?? "{}"
            
            let defaults: UserDefaults = UserDefaults.standard
            
            defaults.set(data, forKey: rateDataKey)
            
            return true
            
        } catch {
            
            return false
        }
    }
    
   
}
