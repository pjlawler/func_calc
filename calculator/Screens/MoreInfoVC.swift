//
//  MoreInfoVC.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/7/22.
//

import UIKit

class MoreInfoVC: UITableViewController {
    
    let tableData: [String] = ["Instructions", "Base Exchange Currency","Current Exchange Rates"]
    let tableFooter = UIView(frame: .zero)
    let copyrightLabel = CopyrightLabel()
    let ratesStatusLabel = UILabel(frame: .zero)
    let cellID = "cellID"
    
    let model = CalculatorModel.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.reloadTableView()
    }
    
    @objc func pullRefresh() {
        
        // if user pulls to refresh, this will try to download the latest rates
        model.updateExchangeRates(completed: {
            if self.model.exchangeRates.isOverHourOld {
                DispatchQueue.main.async { self.reloadTableView() }
            }
        })
        refreshControl?.endRefreshing()
    }
    
    
    func reloadTableView() {
        
        // refreshes the table, and ratesStatus label to show updated base currency and/or rate download status
        
        tableView.reloadData()
        ratesStatusLabel.text = model.exchangeRates.moreInfoMessage
        ratesStatusLabel.textColor = model.exchangeRates.isOverHourOld ? .systemRed : .systemGreen
    }
    
    
    func pushBaseCurrenciesVC() {
        
        // pushes the vc to show the table with the list of countries, allows user to choose a new base currency
        
        let baseCurrenciesVC = BaseCurrenciesVC()
        navigationController?.pushViewController(baseCurrenciesVC, animated: true)
    }
    
    
    func presentRatesVC() {
        
        // presents the current rates vc to show the exchage rates for each country to the base country
        
        let ratesVC = CurrentRatesVC()
        let navigationController = UINavigationController(rootViewController: ratesVC)
        present(navigationController, animated: true)
    }
    
    
    func presentInstructionsVC() {
        
        // presents the vc to see the calculator's instruction
        
        let instructionsVC          = UserInstructionsVC()
        let navigationController    = UINavigationController(rootViewController: instructionsVC)
        present(navigationController, animated: true)
    }
}

// MARK: - TableView Protocol Functions

extension MoreInfoVC {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { tableData.count }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // instantiates the cell to be used in the table view
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MoreInfoCell
        cell.selectionStyle = .none
        cell.set(data: tableData, row: indexPath.row)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 { pushBaseCurrenciesVC() }
    }
    
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        // goes to the respective vc based on which accessoryButton is tapped (row 1 has no accessory button...)
        
        switch indexPath.row {
        case 0: presentInstructionsVC()
        case 2: presentRatesVC()
        default: return
        }
    }
}

// MARK: - Configure View
extension MoreInfoVC {
    
    
    func configureView() {
        title = "Calculator Info"
        
        // sets the pull to refresh action
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(pullRefresh), for: .valueChanged)
        
        // sets up the label displaying the rates download status
        ratesStatusLabel.text = model.exchangeRates.moreInfoMessage
        ratesStatusLabel.textColor = model.exchangeRates.isOverHourOld ? .systemRed : .systemGreen
        ratesStatusLabel.numberOfLines = 2
        ratesStatusLabel.textAlignment = .center
        ratesStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tableFooter.addSubviews(ratesStatusLabel, copyrightLabel)
        
        NSLayoutConstraint.activate([
            ratesStatusLabel.topAnchor.constraint(equalTo: tableFooter.topAnchor, constant: 10),
            ratesStatusLabel.leadingAnchor.constraint(equalTo: tableFooter.leadingAnchor, constant: 10),
            ratesStatusLabel.trailingAnchor.constraint(equalTo: tableFooter.trailingAnchor, constant: -10),
            copyrightLabel.topAnchor.constraint(equalTo: ratesStatusLabel.bottomAnchor, constant: 10),
            copyrightLabel.leadingAnchor.constraint(equalTo: tableFooter.leadingAnchor, constant: 10),
            copyrightLabel.trailingAnchor.constraint(equalTo: tableFooter.trailingAnchor, constant: -10)
        ])
    }
    
    
    func configureTable() {
        tableView.tableFooterView = tableFooter
        tableView.register(MoreInfoCell.self, forCellReuseIdentifier: cellID)
    }
}
