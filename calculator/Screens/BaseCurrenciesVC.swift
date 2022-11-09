//
//  BaseCurrenciesVC.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/7/22.
//

import UIKit

class BaseCurrenciesVC: UITableViewController {

    var tableData: [String] = []
    let cellID = "cellId"
    var currentIndex: IndexPath!
    let model = CalculatorModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        
        title = "Select Base Currency"
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(BaseCurrenciesCell.self, forCellReuseIdentifier: cellID)
        
        // loads the table data with the list of countries from the constant struct
        for country in CountryData.currencyName {
            tableData.append("\(country.value) (\(country.key))")
        }
        
        reloadTable()
        scrollToSelection()
    }
    
    
    private func scrollToSelection() {
        
        // scrolls the table to the currently selected country
        
        for (index, currency) in tableData.enumerated() {
            
            // gets the index of the selected property in the table data
            if getCountryCode(textLine: currency) == model.userDefaults.baseCurrency {
                currentIndex = IndexPath(row: index, section: 0)
            }
        }
        
        tableView.scrollToRow(at: currentIndex, at: .middle, animated: false)
    }
        
    
    private func getCountryCode(textLine: String) -> String {
        
        // gets the country code from the string
        
        let base    = textLine
        let range   = base.index(base.endIndex, offsetBy: -4)...base.index(base.endIndex, offsetBy: -2)
        return String(base[range])
    }
        
    
    private func reloadTable() {
        
        // updates & sorts the table data, hides table if no data
        
        tableView.isHidden = tableData.isEmpty
        tableData.sort()
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! BaseCurrenciesCell
        
        // true if the current row is the selected item
        let isSelectedItem = currentIndex == indexPath
        
        // passes the table information to the cell
        cell.set(rowData: tableData[indexPath.row], isCurrentSelection: isSelectedItem)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCountryCode = getCountryCode(textLine: tableData[indexPath.row])
        
        // sets the user defaults to the newly selected code and updates the saved exchange rates
        model.userDefaults.baseCurrency  = selectedCountryCode
        model.storeUserDefaults()
        model.updateExchangeRates()
        
        // removes modal view controller
        navigationController?.popViewController(animated: true)
    }
}
