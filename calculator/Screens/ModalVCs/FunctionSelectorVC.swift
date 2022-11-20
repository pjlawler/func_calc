//
//  FunctionSelectorVC.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/15/22.
//

import UIKit

enum TableDisplay {
    case formulas
    case conversions
}

protocol FunctionSelectorDelegate {
    func updateButtonTitles()
    func executeFunction(function: String)
}

class FunctionSelectorVC: UIViewController {
    
    var executeButton: UIBarButtonItem!
    
    var functionSelectorDelegate: FunctionSelectorDelegate?
    
    let segment = FCSegmentControl(firstTitle: "Conversions", secondTitle: "Formulas", startOn: 0)
    let infoBox = FunctionSelectorInfoView()
    let table = UITableView()
    
    var sectionExpanded: Int!
    
    let model = CalculatorModel.shared
    
    var formulaList = Functions.formulaList
    var conversionList = Functions.conversionList
    var formulaSelected: String!
    var conversionSelected: [String]!
    
    var tableDisplaying: TableDisplay = .conversions
    var infoTextState = 0
    var fromPresetTag: Int!
    var functionSelected: String!
    var item1: String!
    var item2: String!
    
    let cellID = "cellID"
    
    
    
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
    @objc func selectButtonTapped() {
        
        if fromPresetTag != nil {
            model.userDefaults.functionButtons[fromPresetTag - 100] = functionSelected!
            model.storeUserDefaults()
            functionSelectorDelegate?.updateButtonTitles()
        } else {
            functionSelectorDelegate?.executeFunction(function: functionSelected)
        }
        
        dismiss(animated: true)
    }
    @objc func headerArrowTapped(_ sender: UIButton) {
        let section = sender.tag - 200
        if sectionExpanded == nil { sectionExpanded = section }
        else if sectionExpanded == section { sectionExpanded = nil}
        else { sectionExpanded = section}
        functionSelected = nil
        updateTableView()
        updateInfoBox()
    }
    @objc func showFavoritesTapped(_ sender: UIButton) {
        if model.userDefaults.showingFavorites == nil { model.userDefaults.showingFavorites = true }
        else { model.userDefaults.showingFavorites = !model.userDefaults.showingFavorites! }
        model.storeUserDefaults()
        updateTableView()
        updateInfoBox()
    }
    @objc func segmentChanged() {
        
        tableDisplaying = tableDisplaying == .formulas ? .conversions : .formulas
        sectionExpanded = nil
        functionSelected = nil
        item1 = nil
        item2 = nil
        updateTableView()
        updateInfoBox()
    }
    
    
    
    func updateInfoBox() {
        
        executeButton.isEnabled = (tableDisplaying == .formulas && item1 != nil) || (tableDisplaying == .conversions && item2 != nil)
        infoBox.setInfoBox(displayAs: tableDisplaying, presetTag: fromPresetTag, functionString: functionSelected)
        
    }
    
    // MARK: Configure Views
    
    func configureViewController() {
        title = "Select Function"
        view.backgroundColor = .systemBackground
        
        // configure navbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        executeButton = UIBarButtonItem(title: "Execute", style: .plain, target: self, action: #selector(selectButtonTapped))
        executeButton.isEnabled = false
        navigationItem.leftBarButtonItem = doneButton
        navigationItem.rightBarButtonItem = executeButton
        
        executeButton.isHidden = fromPresetTag != nil
    }
    
    func configureComponents() {
        
        // configure segment control
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        // configure infoBox
        infoBox.infoBoxDelegate = self
        
        
        // configure tableview
        table.allowsMultipleSelection = true
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
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {  return tableHeader(section: section) }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { updateTableSelections() }
    

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) { updateTableSelections()}


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 45 }
    
   
    func tableHeader(section: Int) -> FunctionSelectorListHeader {
        let headerView = FunctionSelectorListHeader()
        
        headerView.arrowButton.addTarget(self, action: #selector(headerArrowTapped), for: .touchUpInside)
        headerView.favoritesButton.addTarget(self, action: #selector(showFavoritesTapped), for: .touchUpInside)
        
        let isExpanded = sectionExpanded != nil && sectionExpanded == section
        headerView.set(data: tableData[section][0], expanded: isExpanded, section: section )
        return headerView
    }
    
    
    func updateTableSelections() {
  
        
        // clears the variables for use testing for the select navbar item
        item1 = nil
        item2 = nil
        
        // ensures that there is something selected in the table if not, it resets everything
        guard table.indexPathsForSelectedRows != nil else {
            functionSelected = nil
            updateInfoBox()
            return
        }
        
        // ensures a maximum rows are select 1 = formulas 2 = conversions
        let maxRows = tableDisplaying == .conversions ? 2 : 1
        if table.indexPathsForSelectedRows?.count == maxRows + 1 {
            table.deselectRow(at: table.indexPathsForSelectedRows![0], animated: false)
        }
        
        // getes the index paths stored in the array
        let indexes = table.indexPathsForSelectedRows!
        
        // updates the item variables if present
        item1 = tableData[indexes[0].section][indexes[0].row].symbol
        if indexes.count == 2 { item2 = tableData[indexes[1].section][indexes[1].row].symbol }
        
        // sets the function display for the info box
        functionSelected = indexes.count == 2 ? "\(item1 ?? "")\(Symbols.convertTo)\(item2 ?? "")" : "\(item1 ?? "")"
        
        updateInfoBox()
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
            segment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            segment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            infoBox.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 20),
            infoBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            infoBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            infoBox.heightAnchor.constraint(equalToConstant: 170),
            table.topAnchor.constraint(equalTo: infoBox.bottomAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    
}

extension FunctionSelectorVC: InfoBoxViewDelegate {
        
    func swapButtonTapped() {
        
        guard item1 != nil && item2 != nil else { return }
        let temp = item1
        item1 = item2
        item2 = temp
        
        functionSelected = "\(item1!)\(Symbols.convertTo)\(item2!)"
        updateInfoBox()
    }
    

    
    func storeButtonTapped(completed: @escaping () -> Void) {
        guard functionSelected  != nil else { return }
        
        if fromPresetTag == nil {
            if let index = model.userDefaults.firstOpenPreset {
                model.userDefaults.functionButtons[index] = functionSelected
                storeCompleted()
                completed()
            }
            else {
                let alert = UIAlertController(title: "Error Storing Preset", message: "There are no empty presets available. Would you like to overwrite the preset in the last button postion?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { [self] _ in
                    model.userDefaults.functionButtons[7] = functionSelected
                    storeCompleted()
                    completed()
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    completed()
                }))
                
                present(alert, animated: true)
            }
        }
        
        else {
            model.userDefaults.functionButtons[fromPresetTag - 100] = functionSelected
            storeCompleted()
        }
        
        
        
    }
    
    func storeCompleted() {
        model.storeUserDefaults()
        functionSelectorDelegate?.updateButtonTitles()
        if fromPresetTag != nil { dismiss(animated: true) }
    }
}
