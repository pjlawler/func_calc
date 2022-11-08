//
//  BaseCurrenciesVC.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/7/22.
//

import UIKit

class BaseCurrenciesVC: UITableViewController {

    var tableData: [String] = []
    let cellID              = "cellId"
    var currentIndex: IndexPath!
    let model = CalculatorModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select Base Currency"
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(BaseCurrenciesCell.self, forCellReuseIdentifier: cellID)
                
        for country in CountryData.currencyName {
            tableData.append("\(country.value) (\(country.key))")
        }
        
        reloadTable()
        scrollToSelection()
    }
    
    func scrollToSelection() {
        for (index, currency) in tableData.enumerated() {
            if getCountryCode(textLine: currency) == model.userDefaults.baseCurrency {
                currentIndex = IndexPath(row: index, section: 0)
            }
        }
        tableView.scrollToRow(at: currentIndex, at: .middle, animated: false)
    }
    
    
    func reloadTable() {
        tableView.isHidden = tableData.isEmpty
        tableData.sort()
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! BaseCurrenciesCell
        let currentSelection = currentIndex == indexPath
        cell.set(line: tableData[indexPath.row], currentSelection: currentSelection)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = getCountryCode(textLine: tableData[indexPath.row])
        model.userDefaults.baseCurrency  = text
        model.storeUserDefaults()
        model.updateExchangeRates()
        navigationController?.popViewController(animated: true)
    }
    
    
    func getCountryCode(textLine: String) -> String {
        let base    = textLine
        let range   = base.index(base.endIndex, offsetBy: -4)...base.index(base.endIndex, offsetBy: -2)
        return String(base[range])
    }
}
