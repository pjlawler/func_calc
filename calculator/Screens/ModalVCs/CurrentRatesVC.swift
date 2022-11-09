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
    var exchangeRates: [Currency]               = []
    var searchingRates: [Currency]              = []
    var model = CalculatorModel.shared
    var showingFavorites = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureView()
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
        getLatestExchangeRates()
    }
    
    
    func getLatestExchangeRates() {
        exchangeRates.removeAll()
        table.isHidden = true
        showingFavorites = model.userDefaults.showingFavorites ?? false
        favoriteButton.isSelected = showingFavorites
        
        for country in CountryData.currencyName {
            var currency = Currency()
            let isFavorite = model.userDefaults.favorites?.contains(country.key) ?? false
            
            currency.rateToBase = model.exchangeRates.rates[country.key]! ?? 0.0
            currency.base = model.exchangeRates.base
            currency.code = country.key
            currency.favorited = isFavorite
            currency.name = country.value
            
            if !showingFavorites || (showingFavorites && isFavorite) {
                exchangeRates.append(currency)
            }
            
        }
        reloadTable()
    }
    
    
    
    //MARK: - Users' Inputs
    @objc func doneButtonTapped() { dismiss(animated: true) }
    @objc func segmentChanged() { reloadTable() }
    @objc func mainFavoriteButtonTapped(sender: FavoriteButton) {
        print("toggle rates tapped")
        model.userDefaults.showingFavorites = !showingFavorites
        model.storeUserDefaults()
        getLatestExchangeRates()
//        toggleFavorites(sender: sender)
    }
    @objc func rateFavoriteButtonTapped(sender: FavoriteButton) {
        print("favorite rate tapped")
        print("\(sender.tag):\(sender.isSelected)")
                
        if sender.isSelected {
            guard model.userDefaults.favorites != nil else { return }
            model.userDefaults.favorites!.removeAll(where: { $0 == exchangeRates[sender.tag].code })
        }
        else {
            if model.userDefaults.favorites == nil { model.userDefaults.favorites = [] }
            model.userDefaults.favorites?.append(exchangeRates[sender.tag].code)
        }
        sender.toggle()
        
        model.storeUserDefaults()
        getLatestExchangeRates()
        
//        toggleRateFavorite(sender: sender)
    }
}

extension CurrentRatesVC: UITableViewDelegate, UITableViewDataSource {
    
    func reloadTable() {
        
        switch self.segment.selectedSegmentIndex {
        case 0:
            self.exchangeRates.sort(by: { $0.name < $1.name })
            self.searchingRates.sort(by: { $0.name < $1.name })
        case 1:
            self.exchangeRates.sort(by: { $0.code < $1.code })
            self.searchingRates.sort(by: { $0.code < $1.code })
        default:
            break
        }
        
        table.reloadData()
        table.isHidden = false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchingRates.count : exchangeRates.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = isSearching ? searchingRates[indexPath.row] : exchangeRates[indexPath.row]
        
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
            searchingRates = exchangeRates.filter({ $0.name.lowercased().contains(searchText) || $0.code.lowercased().contains(searchText) })
            isSearching = true
        }
        reloadTable()
    }
}
