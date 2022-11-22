//
//  MoreInfoVC.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/7/22.
//

import UIKit

protocol MoreInfoDelegate {
    func clearAllPresets()
}

class MoreStuffVC: UIViewController {
    
    let refreshControl = UIRefreshControl()
    let tableView = UITableView(frame: .zero)
    var tableData: [String] = []
    let copyrightLabel = CopyrightLabel()
    let ratesStatusLabel = UILabel(frame: .zero)
    let cellID = "cellID"
    let model = CalculatorModel.shared
    let buttonTitles = ["View", "Change", "View", "Erase"]
    var moreInfoDelegate: MoreInfoDelegate?
    var tableHeader = UIView(frame: .zero)
    let pullToRefreshLabel = UILabel(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureComponents()
        layoutViews()
        reloadTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadTableView()
    }
    
    @objc func pullRefresh() {
        
        // if user pulls to refresh, this will try to download the latest rates
        
        if model.exchangeRates.isOverHourOld {
            model.updateExchangeRates(completed: {
                DispatchQueue.main.async { self.reloadTableView() }
            })
        }
        
        refreshControl.endRefreshing()
    }
    
    @objc func buttonHandler(sender: MoreStuffButton) {
        switch sender.tag {
        case 0: presentRatesVC()
        case 1: pushBaseCurrenciesVC()
        case 2: presentInstructionsVC()
        case 3: clearAllPresets()
        default: break
        }
    }
    
    func clearAllPresets() {
        
        // displays an alert to confirm clearing all presets
        
        presentMultipleChoiceAlertOnMainThread(title: "Erase All Presets!", message: "Are you sure?", actions: ["Erase":.default, "Cancel":.cancel], style: .alert) { choice in
            if choice == "Erase" { self.moreInfoDelegate?.clearAllPresets() }
        }

    }
    
    func reloadTableView() {
        tableData = ["Exchange Rates", "Current Base currency (\(model.userDefaults.baseCurrency ?? "None"))", "FunctionCalc instructions", "Erase function button presets"]
        // refreshes the table, and ratesStatus label to show updated base currency and/or rate download status
        
        tableView.reloadData()
        ratesStatusLabel.text = model.exchangeRates.moreInfoMessage
        ratesStatusLabel.textColor = model.exchangeRates.isOverHourOld ? .systemRed : .systemGreen
    }
    
    
    func pushBaseCurrenciesVC() {
        
        // pushes the vc that shows the table with the list of countries, allows user to choose a new base currency
        
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


extension MoreStuffVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // instantiates the cell to be used in the table view
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MoreInfoCell
        cell.selectionStyle = .none
        cell.set(item: tableData[indexPath.row], buttonTitle: buttonTitles[indexPath.row], tag: indexPath.row)
        cell.button.addTarget(self, action: #selector(buttonHandler), for: .touchUpInside)
        return cell
    }
}

// MARK: - Configure View

extension MoreStuffVC {
    
    func configureView() {
        title = "More Stuff"
        view.backgroundColor = .systemBackground
        
    }
    
    
    func configureComponents() {

        
        // sets the pull to refresh action
        refreshControl.addTarget(self, action: #selector(pullRefresh), for: .valueChanged)
        
        pullToRefreshLabel.textAlignment = .center
        pullToRefreshLabel.text = "(Pull to Update)"
        pullToRefreshLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        // sets up the label displaying the rates download status
        ratesStatusLabel.text = model.exchangeRates.moreInfoMessage
        ratesStatusLabel.textColor = model.exchangeRates.isOverHourOld ? .systemRed : .systemGreen
        ratesStatusLabel.numberOfLines = 2
        ratesStatusLabel.textAlignment = .center
        ratesStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // configures table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MoreInfoCell.self, forCellReuseIdentifier: cellID)
        tableView.refreshControl = refreshControl
        tableView.translatesAutoresizingMaskIntoConstraints = false

        // more stuff view
        
    }
    
    func layoutViews() {
        
        view.addSubviews(copyrightLabel, ratesStatusLabel, pullToRefreshLabel, tableView)
        NSLayoutConstraint.activate([
            copyrightLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            copyrightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pullToRefreshLabel.topAnchor.constraint(equalTo: ratesStatusLabel.bottomAnchor, constant: 5),
            pullToRefreshLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),  
            ratesStatusLabel.topAnchor.constraint(equalTo: copyrightLabel.bottomAnchor, constant: 10),
            ratesStatusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: pullToRefreshLabel.bottomAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
           
        ])
    }
}
