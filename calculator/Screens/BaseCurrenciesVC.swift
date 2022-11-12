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
        
        tableView.register(BaseCurrenciesCell.self, forCellReuseIdentifier: cellID)
        
        // loads the table data with the list of countries from the constant struct
        for country in CountryData.currencyName {
            tableData.append("\(country.value) (\(country.key))")
        }
        
        reloadTable()
        scrollToSelection()
    }
    
    
    private func dismissOnMainThread() {

        DispatchQueue.main.async {
            // removes modal view controller
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    private func scrollToSelection() {
        
        // scrolls the table to the currently selected country
        
        for (index, currency) in tableData.enumerated() {
            
            // gets the index of the selected property in the table data
            if getCountryCode(textLine: currency) == model.userDefaults.baseCurrency {
                currentIndex = IndexPath(row: index, section: 0)
            }
        }
        
        guard currentIndex != nil else { return }
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
        let isSelectedItem = currentIndex ?? IndexPath(row: -1, section: 0 ) == indexPath
        
        // passes the table information to the cell
        cell.set(rowData: tableData[indexPath.row], isCurrentSelection: isSelectedItem)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCountryCode = getCountryCode(textLine: tableData[indexPath.row])
        
        // sets the user defaults to the newly selected code and updates the saved exchange rates
        model.userDefaults.baseCurrency  = selectedCountryCode
        model.updateExchangeRates(completed: {
            if self.model.exchangeRates.base != self.model.userDefaults.baseCurrency {
                
                // if the exchanges were not updated with the new base, then resets back to the old data and gives a warning message
                
                self.model.userDefaults.baseCurrency = self.model.exchangeRates.base
                self.model.storeUserDefaults()
                let message = "Due to a network issue, the base country cannot be changed at this time.  Please try again later."
                self.presentAlertOnMainThread(title: "Network Problem", message: message)
            }
            else {
                
                // if everything changed correctly then goes back to the MoreInfoVC
                self.dismissOnMainThread()
            }
        })
    }
}
