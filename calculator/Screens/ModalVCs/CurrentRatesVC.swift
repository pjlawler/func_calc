//
//  CurrentRatesVC.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/7/22.
//

import UIKit

class CurrentRatesVC: UIViewController {
    
    let table = UITableView()
    let favoriteButton = FavoriteButton(frame: .zero)
    let segment = FCSegmentControl(firstTitle: "Currency Name", secondTitle: "Currency Code", startOn: 0)
    let searchBar = UISearchBar()
    let segmentTitleLabel = UILabel()
    
    let padding: CGFloat = 10
    let model = CalculatorModel.shared
    
    var searchBarText = ""
    var isSearching = false
    var showingFavorites = false
        
    var rateDataAll: [Currency] = []
    var rateDataSearching: [Currency] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        updateTableData()
    }
    
    //MARK: - Users' Inputs
    @objc func doneButtonTapped() { dismiss(animated: true) }
    @objc func segmentChanged() { reloadTable() }
    @objc func rateFavoriteButtonTapped(sender: FavoriteButton) { toggleFavoriteCurrency(sender: sender) }
    @objc func mainFavoriteButtonTapped(sender: FavoriteButton) { toggleShowOnlyFavorites(sender: sender) }
    
    
    private func updateTableData() {
        
        guard model.exchangeRates.rates?.count ?? 0 > 0 else { return }
        
        // retrieves user default if showing only favorites or not, not if nil
        showingFavorites = model.userDefaults.showingFavorites ?? false

        // sets the favorites navbar button if showing favorites
        favoriteButton.isSelected = showingFavorites

        // empties the exchange rates data arrays
        rateDataAll.removeAll()
        rateDataSearching.removeAll()
        
        // iterates through each of the available countries loaded in the country name constant
        for country in CountryData.currencyName {
            
            // creates a currency object to hold the data
            var currency = Currency()
            
            // sets true if the country code is found in the favorites user defaults array
            let isFavorite = model.userDefaults.favorites?.contains(country.key) ?? false
            
            // populates the data for the object
            currency.rateToBase = model.exchangeRates.rates?[country.key]! ?? 0.0
            currency.base = model.exchangeRates.base
            currency.code = country.key
            currency.favorited = isFavorite
            currency.name = country.value
            
            // adds the data to the array depending on if showing favorites or not, and if the rate is favorited
            if !showingFavorites || (showingFavorites && isFavorite) { rateDataAll.append(currency) }
            
            if isSearching {
                
                // resets the 'searching' data array if the table changes while using the search bar (i.e. favorites tapped)
                rateDataSearching = rateDataAll.filter({ $0.name.lowercased().contains(searchBarText) || $0.code.lowercased().contains(searchBarText) })
            }
        }
        
        reloadTable()
    }
    
    private func reloadTable() {
        
        // sorts and reloads the table data depending on which segment is selected
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
    
    
    private func toggleFavoriteCurrency(sender: FavoriteButton) {
        
        // favorties/unfavorites individual countries, then updates the user defaults' favorites array
        
        // ensures the target country is found in the data array
        guard let tappedCountryCode = isSearching ? rateDataSearching[sender.tag].code : rateDataAll[sender.tag].code else { return }
        
        if sender.isSelected {
            
            // if the country is currently favorited, then unfavorties it
            
            // ensures the favorites array is not nil
            guard model.userDefaults.favorites != nil else { return }
            
            // removes the country code from the user defaults favorites array
            model.userDefaults.favorites!.removeAll(where: { $0 == tappedCountryCode })
            sender.isSelected = false
        }
        
        else {
            
            // if the country is not currently favorited, then favorites it
        
            // creates an empty array if the favorites array is nil
            if model.userDefaults.favorites == nil { model.userDefaults.favorites = [] }
            
            // adds the favorted country code to the user defaults favorites array
            model.userDefaults.favorites?.append(tappedCountryCode)
            sender.isSelected = true
        }
        
        model.storeUserDefaults()
        updateTableData()
    }
    
    
    private func toggleShowOnlyFavorites(sender: FavoriteButton) {
        
        // toggles if showing favorites in the table and stores the choice in user defaults
        model.userDefaults.showingFavorites = !showingFavorites
        model.storeUserDefaults()
        updateTableData()
    }
}

extension CurrentRatesVC: UITableViewDelegate, UITableViewDataSource {
    
    // tableview protocal functions
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // returns the array length depending if searching or not
        return isSearching ? rateDataSearching.count : rateDataAll.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // gets the item from the data array, depending if the user is search or not
        let data = isSearching ? rateDataSearching[indexPath.row] : rateDataAll[indexPath.row]
        
        // creates the cell
        let cell = table.dequeueReusableCell(withIdentifier: "ratesTableCell") as! RatesTableCell
        
        // keeps the cell from being selectable (view only)
        cell.selectionStyle = .none
        cell.set(rateData: data)
                
        // adds the taget for the favorites button on cell
        cell.button.addTarget(self, action: #selector(rateFavoriteButtonTapped(sender:)), for: .touchUpInside)
        
        // adds the index of data to the tag for use when favoriting/unfavorting the currency
        cell.button.tag = indexPath.row
        
        return cell
    }
}

extension CurrentRatesVC: UISearchBarDelegate {
    
    // SearchBar protocol functions
    
    
    // sets the isSearching variable to true and filters the rateDataAll array with countries that match what's in the searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            isSearching = false
        }
        else {
            searchBarText = searchBar.text!.lowercased()
            rateDataSearching = rateDataAll.filter({ $0.name.lowercased().contains(searchBarText) || $0.code.lowercased().contains(searchBarText) })
            isSearching = true
        }
        
        reloadTable()
    }
}

// MARK: - UI Configuration
extension CurrentRatesVC {
    
    func configureView() {
        title = "Currency Rates to \(String(describing: model.exchangeRates.base ?? ""))"
        view.backgroundColor = .systemBackground
        
        // sets up so a tap on the screen will dismiss the keyboard when typing in the search bar
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        // sets up the navbar with the done and favorite buttons
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let showFavorites = UIBarButtonItem(customView: favoriteButton)
        favoriteButton.addTarget(self, action: #selector(mainFavoriteButtonTapped(sender:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem    = doneButton
        navigationItem.rightBarButtonItem   = showFavorites

        searchBar.delegate      = self
        table.delegate          = self
        table.dataSource        = self
        
        segmentTitleLabel.text = "Sort rates by:"
        segmentTitleLabel.textAlignment = .center
        segmentTitleLabel.font = Fonts.modalVCInfoText
        segmentTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        searchBar.isTranslucent = true
        searchBar.placeholder   = "Currency"
        searchBar.sizeToFit()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        table.isHidden = true
        table.delaysContentTouches = false
        table.register(RatesTableCell.self, forCellReuseIdentifier: "ratesTableCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        
        // adds the views to the VC's view
        view.addSubview(segmentTitleLabel)
        view.addSubview(segment)
        view.addSubview(searchBar)
        view.addSubview(table)
        
        NSLayoutConstraint.activate([
            segmentTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            segmentTitleLabel.bottomAnchor.constraint(equalTo: segment.topAnchor, constant: -padding),
            segmentTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            segmentTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            segmentTitleLabel.centerXAnchor.constraint(equalTo: segment.centerXAnchor),
            segment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            segment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            segment.topAnchor.constraint(equalTo: segmentTitleLabel.bottomAnchor, constant: padding),
            searchBar.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: padding),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


