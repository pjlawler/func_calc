//
//  CurrentRatesVC.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/7/22.
//

import UIKit

class CurrentRatesVC: UIViewController {
    
    let table                                   = UITableView()
    let favoriteButton                          = FavoriteButton(frame: .zero)
    let segment                                 = FCSegmentControl(firstTitle: "Currency Name", secondTitle: "Currency Code", startOn: 0)
    let searchBar                               = UISearchBar()
    var isSearching                             = false
    let padding: CGFloat                        = 10
    var rateDataAll: [Currency]               = []
    var rateDataSearching: [Currency]              = []
    var model = CalculatorModel.shared
    var showingFavorites = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTableView()
        configureSearchBar()
        configureSegmentedControl()
        updateTableData()
    }
    
    
    func updateTableData() {
        
        // retrieves user default if showing only favorites or not, not if nil
        showingFavorites = model.userDefaults.showingFavorites ?? false

        // sets the favorites navbar button if showing favorites
        favoriteButton.isSelected = showingFavorites

        // empties the exchangerates data array
        rateDataAll.removeAll()
        
        // iterates through each of the available countries loaded in the country name constant
        for country in CountryData.currencyName {
            
            // creates a currency object to hold the data
            var currency = Currency()
            
            // sets true if the country code is found in the favorites user defaults array
            let isFavorite = model.userDefaults.favorites?.contains(country.key) ?? false
            
            // populates the data for the object
            currency.rateToBase = model.exchangeRates.rates[country.key]! ?? 0.0
            currency.base = model.exchangeRates.base
            currency.code = country.key
            currency.favorited = isFavorite
            currency.name = country.value
            
            // adds the data to the array depending on if showing favorites or not, and if the rate is favorited
            if !showingFavorites || (showingFavorites && isFavorite) {
                rateDataAll.append(currency)
            }
        }
        
        reloadTable()
    }
        
    
    //MARK: - Users' Inputs
    @objc func doneButtonTapped() { dismiss(animated: true) }
    @objc func segmentChanged() { reloadTable() }
    @objc func mainFavoriteButtonTapped(sender: FavoriteButton) {
        
        // toggles if showing favorites in the table and stores the choice in user defaults
        model.userDefaults.showingFavorites = !showingFavorites
        model.storeUserDefaults()
        
        updateTableData()

    }
    
    @objc func rateFavoriteButtonTapped(sender: FavoriteButton) {

        // updates the user defaults favorites array depending on the state
        let isFavorited = sender.isSelected
        
        if isFavorited {
            guard model.userDefaults.favorites != nil else { return }
            
            // removes the country code from the user defaults favorites array
            model.userDefaults.favorites!.removeAll(where: { $0 == rateDataAll[sender.tag].code })
        }
        else {
            // ensures the favorites array is not nil
            if model.userDefaults.favorites == nil { model.userDefaults.favorites = [] }
            
            // adds the favorted country code to the user defaults favorites array
            model.userDefaults.favorites?.append(rateDataAll[sender.tag].code)
        }
        
        model.storeUserDefaults()
        
        // toggles the button's selected state and stores
        sender.toggle()
        
        updateTableData()
    }
}

extension CurrentRatesVC: UITableViewDelegate, UITableViewDataSource {
    
    func reloadTable() {
        
        // sorts the table data depending on which segment is selected
        switch self.segment.selectedSegmentIndex {
        
        case 0:
            // sorts the data by country name
            self.rateDataAll.sort(by: { $0.name < $1.name })
            self.rateDataSearching.sort(by: { $0.name < $1.name })
        
        case 1:
            // sorts the data by currency code
            self.rateDataAll.sort(by: { $0.code < $1.code })
            self.rateDataSearching.sort(by: { $0.code < $1.code })
        default:
            break
        }
        
        table.reloadData()
        table.isHidden = false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // returns the array length depending if searching or not
        return isSearching ? rateDataSearching.count : rateDataAll.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = isSearching ? rateDataSearching[indexPath.row] : rateDataAll[indexPath.row]
        
        let cell = table.dequeueReusableCell(withIdentifier: "ratesTableCell") as! RatesTableCell
        cell.selectionStyle = .none
        cell.set(rateData: data)
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(rateFavoriteButtonTapped(sender:)), for: .touchUpInside)
        
        return cell
    }
}

// MARK: - UI Configuration
extension CurrentRatesVC {
    
    func configureView() {
        let toCurrency                      = "to \(model.exchangeRates.base)"
        title                               = "Currency Rates \(toCurrency)"
        view.backgroundColor                = .systemBackground
                
        favoriteButton.addTarget(self, action: #selector(mainFavoriteButtonTapped(sender:)), for: .touchUpInside)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let showFavorites = UIBarButtonItem(customView: favoriteButton)
        
        navigationItem.leftBarButtonItem    = doneButton
        navigationItem.rightBarButtonItem   = showFavorites
        
        
        view.addSubview(table)
        view.addSubview(segment)
        view.addSubview(searchBar)
    }
    
    
    func configureSearchBar() {
        
        searchBar.delegate      = self
        searchBar.isTranslucent = true
        searchBar.placeholder   = "Currency"
        searchBar.sizeToFit()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: padding),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    func configureTableView() {
        let tableFooter         = UIView(frame: .zero)
        table.isHidden = true
        table.delaysContentTouches = false
        table.delegate          = self
        table.dataSource        = self
        table.tableFooterView   = tableFooter
        table.register(RatesTableCell.self, forCellReuseIdentifier: "ratesTableCell")
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: padding),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
        
    }
    
    
    func configureSegmentedControl() {
        let titleLabel  = UILabel()
        titleLabel.text = "Sort rates by:"
        titleLabel.font = Fonts.modalVCInfoText
        
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)

        NSLayoutConstraint.activate([
            segment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            segment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            segment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding + 30),
            titleLabel.bottomAnchor.constraint(equalTo: segment.topAnchor, constant: -padding),
            titleLabel.centerXAnchor.constraint(equalTo: segment.centerXAnchor)
        ])
    }
}

extension CurrentRatesVC: UISearchBarDelegate, UISearchTextFieldDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            isSearching = false
        }
        else {
            let searchText = searchBar.text!.lowercased()
            rateDataSearching = rateDataAll.filter({ $0.name.lowercased().contains(searchText) || $0.code.lowercased().contains(searchText) })
            isSearching = true
        }
        reloadTable()
    }
}
