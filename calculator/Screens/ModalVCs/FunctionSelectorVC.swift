//
//  FunctionSelectorVC.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/15/22.
//

import UIKit

class FunctionSelectorVC: UIViewController {
   
    var selectButton: UIBarButtonItem!
    let infoBox = InformationBoxView()
    let table = UITableView()
    let segment = FCSegmentControl(firstTitle: "Formulas", secondTitle: "Conversions", startOn: 0)
    var sectionExpanded: Int!
    
    let model = CalculatorModel.shared
    
    var formulaList = Functions.formulaList
    var conversionList = Functions.conversionList
    
    var tableDisplaying: displayTable = .formulas
    var infoTextState = 0
    var fromPresetTag: Int!
    var functionSelected: String!
    
    let cellID = "cellID"
    
    enum displayTable {
        case formulas
        case conversions
    }
    
    
    var tableData:[[FunctionData]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureComponents()
        layoutComponents()
        updateTableView()
        updateInfoBox()
    }
        
    // MARK: User Inputs
    
    @objc func doneButtonTapped() { dismiss(animated: true) }
    @objc func selectButtonTapped() {}
    @objc func headerArrowTapped(_ sender: UIButton) {
        let section = sender.tag - 200
        if sectionExpanded == nil { sectionExpanded = section }
        else if sectionExpanded == section { sectionExpanded = nil}
        else { sectionExpanded = section}
        updateTableView()

    }
    @objc func showFavoritesTapped(_ sender: UIButton) {
        if model.userDefaults.showingFavorites == nil { model.userDefaults.showingFavorites = true }
        else { model.userDefaults.showingFavorites = !model.userDefaults.showingFavorites! }
        model.storeUserDefaults()
        updateTableView()
    }
    @objc func segmentChanged() {

        if tableDisplaying == .formulas {
            tableDisplaying = .conversions
        }
        else {
            tableDisplaying = .formulas
        }
        
        sectionExpanded = nil
        functionSelected = nil
        updateTableView()
        updateInfoBox()
    }
    
    
    
    func updateInfoBox() {
        
        switch tableDisplaying {
        case .conversions:
            if functionSelected == nil && fromPresetTag == nil {
                infoTextState = 1
                selectButton.isEnabled = false
            }
            else if functionSelected != nil && fromPresetTag == nil {
                infoTextState = 3
                
            }
        case .formulas:
            if functionSelected == nil && fromPresetTag == nil {
                infoTextState = 0
                selectButton.isEnabled = false
            }
            else if functionSelected != nil && fromPresetTag == nil {
                infoTextState = 2
                selectButton.isEnabled = true
            }
        }
                
        switch infoTextState {
        case 0: infoBox.setBoxState(state: .formulaFromNavbar)
        case 1: infoBox.setBoxState(state: .conversionFromNavbar)
        case 2: infoBox.setBoxState(state: .formulaSelected, functionString: functionSelected)
        default:
            break
        }
    }
    
    // MARK: Configure Views
    
    func configureViewController() {
        title = "Select Function"
        view.backgroundColor = .systemBackground
        
        // configure navbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        selectButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonTapped))
        selectButton.isEnabled = false
        navigationItem.leftBarButtonItem = doneButton
        navigationItem.rightBarButtonItem = selectButton
    }
    
    func configureComponents() {
       
        // configure segment control
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        // configure tableview
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(FunctionListCell.self, forCellReuseIdentifier: cellID)
    }
}

// MARK: TableView Functions

extension FunctionSelectorVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // if the section is not expanded then returns no rows
        let isExpanded = sectionExpanded != nil && sectionExpanded == section
        return isExpanded ? tableData[section].count : 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! FunctionListCell
        cell.setCellData(data: tableData[indexPath.section][indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = FunctionSelectorListHeader()
        
        headerView.arrowButton.addTarget(self, action: #selector(headerArrowTapped), for: .touchUpInside)
        headerView.favoritesButton.addTarget(self, action: #selector(showFavoritesTapped), for: .touchUpInside)
        
        let isExpanded = sectionExpanded != nil && sectionExpanded == section
        headerView.set(data: tableData[section][0], expanded: isExpanded, section: section )
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        functionSelected = tableData[indexPath.section][indexPath.row].symbol
        updateInfoBox()
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func updateTableView() {
        
        // puts the preprogrammed formulas or conversions into tableData 2d array depending on the table displaying variable
        tableData = tableDisplaying == .formulas ? formulaList : conversionList
        
        // sets based on what's save in user defaults
        let showingFavorites = model.userDefaults.showingFavorites ?? false
    
        // adds the currency conversion options to the table data if displaying conversions
        if tableDisplaying == .conversions {
            
            var currencySection: [FunctionData] = []
            
            for country in CountryData.currencyName {
                let isFavorited = model.userDefaults.favorites?.contains(country.key) ?? false
                let currencyConversion = FunctionData(category: Categories.currency, title: country.value, symbol: country.key, favorite: isFavorited)
                if isFavorited && showingFavorites || !showingFavorites {currencySection.append(currencyConversion)}
            }
            
            tableData.append(currencySection)
        }

        // sort by section, then by title inside each section
        tableData.sort(by: { $0[0].category < $1[0].category })
        // sorts each section by title
        for (index, _) in tableData.enumerated() { tableData[index].sort(by: { $0.title < $1.title }) }
                
        table.reloadData()
    }
}

extension FunctionSelectorVC {
    
    func layoutComponents() {
        
        view.addSubviews(infoBox, table, segment)
        
        NSLayoutConstraint.activate([
            segment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            segment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            infoBox.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 10),
            infoBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            infoBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            infoBox.heightAnchor.constraint(equalToConstant: 170),
            table.topAnchor.constraint(equalTo: infoBox.bottomAnchor, constant: 10),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    
}
