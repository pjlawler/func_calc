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
    let cellID = "cellID"
    let model = CalculatorModel.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTable()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }


    func settingSelected(row: Int) {
           switch row {
           case 0: presentInstructionsVC()
           case 1: pushBaseCurrenciesVC()
           case 2: presentRatesVC()
           default: return
           }
       }
    
    
    func pushBaseCurrenciesVC() {
           let baseCurrenciesVC  = BaseCurrenciesVC()
           navigationController?.pushViewController(baseCurrenciesVC, animated: true)
       }
    
    
    func presentRatesVC() {
        let ratesVC                 = CurrentRatesVC()
        let navigationController    = UINavigationController(rootViewController: ratesVC)
        present(navigationController, animated: true)
    }
    
    
    func presentInstructionsVC() {
//        let instructionsVC          = FCUserInstructionsVC()
//        let navigationController    = UINavigationController(rootViewController: instructionsVC)
//        present(navigationController, animated: true)
    }
}

extension MoreInfoVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { tableData.count }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MoreInfoCell
        cell.set(data: tableData, row: indexPath.row)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { settingSelected(row: indexPath.row) }
    
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) { settingSelected(row: indexPath.row) }
}

// MARK: - Configure View
extension MoreInfoVC {
    
    func configureView() {
        title = "Calculator Info"
        tableFooter.addSubview(copyrightLabel)

        NSLayoutConstraint.activate([
            copyrightLabel.topAnchor.constraint(equalTo: tableFooter.topAnchor, constant: 10),
            copyrightLabel.centerXAnchor.constraint(equalTo: tableFooter.centerXAnchor),
        ])
    }
    
    
    func configureTable() {
        tableView.tableFooterView = tableFooter
        tableView.register(MoreInfoCell.self, forCellReuseIdentifier: cellID)
    }
}
