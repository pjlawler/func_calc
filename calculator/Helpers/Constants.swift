//
//  Constants.swift
//  calculator
//
//  Created by Patrick Lawler on 11/2/22.
//


import UIKit

struct Constants {
    static var showFavoriteRates    = false
    static var baseCurrency         = "USD"
    static let appCopyright         = """
    ⓒ 2022 Lawler Innovations, Inc.
    All rights reserved.
    """
}

enum CalcModes {
    case all_clear
    case entering_first
    case awaiting_second
    case entering_second
    case operation_complete
    case displaying_error
}

struct Fonts {
    static let keypadButton         = UIFont.systemFont(ofSize: 36, weight: .regular)
    static let keypadButton_hl      = UIFont.systemFont(ofSize: 40, weight: .bold)
    static let mainDisplayText      = UIFont.systemFont(ofSize: 95, weight: .thin)
    static let auxDisplayText       = UIFont.systemFont(ofSize: 24, weight: .regular)
    static let copyRightDisplayText = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let currencyCodeText     = UIFont.systemFont(ofSize: 17, weight: .bold)
    static let currencyNameText     = UIFont.systemFont(ofSize: 17, weight: .bold)
    static let currencyRate         = UIFont.systemFont(ofSize: 17, weight: .bold)
    static let modalVCInfoText      = UIFont.systemFont(ofSize: 15, weight: .regular)
    static let sectionTitleText     = UIFont.systemFont(ofSize: 17, weight: .bold)
    static let sectionItemText      = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let infoBoxTitle         = UIFont.systemFont(ofSize: 17, weight: .bold)
    static let infoBoxText          = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let functionButtonText   = UIFont.systemFont(ofSize: 14, weight: .bold)
    static let functionDisplay      = UIFont.systemFont(ofSize: 30, weight: .light)
    static let alertInfoBoxText     = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let alertInfBoxTitle     = UIFont.systemFont(ofSize: 17, weight: .bold)
    static let actionButtonText     = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let titleMoreInfo        = UIFont.systemFont(ofSize: 28, weight: .regular)
    static let copyright            = UIFont.systemFont(ofSize: 13, weight: .regular)
    static let instructSubTitle     = UIFont.systemFont(ofSize: 20, weight: .regular)
    static let instructBody         = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let instructHeader       = UIFont.systemFont(ofSize: 17, weight: .bold)
    static let rateCellLabel        = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let settingsItem         = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let settingsDetail       = UIFont.systemFont(ofSize: 17, weight: .regular)
}

struct Symbols {
    static let plusMinus: Character     = "\u{2213}"
    static let plus: Character          = "\u{002B}"
    static let minus: Character         = "\u{2212}"
    static let multiply: Character      = "\u{00D7}"
    static let divide: Character        = "\u{00F7}"
    static let equals: Character        = "\u{003D}"
    static let percent: Character       = "\u{0025}"
    static let colon: Character         = "\u{003A}"
    static let convertTo: Character     = "\u{21A6}"
    static let celsius: Character       = "\u{2103}"
    static let fahrenheit: Character    = "\u{2109}"
    static let dollar: Character        = "\u{0024}"
    static let euro: Character          = "\u{20AC}"
    static let yen: Character           = "\u{00A5}"
    static let pound: Character         = "\u{00A3}"
    static let baht: Character          = "\u{0E3F}"
    static let peso: Character          = "\u{20B1}"
    static let won: Character           = "\u{20A9}"
    static let ruble: Character         = "\u{20BD}"
    static let lira: Character          = "\u{20BA}"
    static let hryvna: Character        = "\u{20B4}"
    static let shekel: Character        = "\u{20AA}"
    static let naira: Character         = "\u{20A6}"
    static let taka: Character          = "\u{09F3}"
    static let yuan: Character          = "\u{5143}"
    static let rupee: Character         = "\u{20B9}"
    static let dong: Character          = "\u{20AB}"
    static let bitcoin: Character       = "\u{20BF}"
    static let lari: Character          = "\u{20BE}"
    static let hourglass: Character     = "\u{29D6}"
    }


struct ImageSymbols {
    static let buttonGrid           = UIImage(systemName: "square.grid.4x3.fill")
    static let dollarSign           = UIImage(systemName: "dollarsign.circle")
    static let infoCircle           = UIImage(systemName: "info.circle")
    static let functionSym          = UIImage(systemName: "function")
    static let settingsGear         = UIImage(systemName: "gear")
    static let arrowRight           = UIImage(systemName: "arrowtriangle.right.fill")
    static let arrowDown            = UIImage(systemName: "arrowtriangle.down.fill")
    static let arrowupdown          = UIImage(systemName: "arrow.up.arrow.down")
    static let alertExclamation     = UIImage(systemName: "exclamationmark.circle", withConfiguration: UIImage.SymbolConfiguration(textStyle: .body))
    static let favoriteStar         = UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title2))
    static let favoriteStarFill     = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title2))
    static let hourglass            = UIImage(systemName: "hourglass")
}


struct Categories {
    static let automotive   = "Automotive"
    static let electronics  = "Electronics"
    static let aviation     = "Aviation"
    static let health       = "Health"
    static let trig         = "Trigonometry"
    static let area         = "Area"
    static let force        = "Force"
    static let construction = "Construction"
    static let financial    = "Financial"
    static let length       = "Length/Distance"
    static let mass         = "Mass/Weight"
    static let temperature  = "Temperature"
    static let velocity     = "Velocity/Speed"
    static let volume       = "Volume"
    static let currency     = "Currency"
    static let metals       = "Precious Metal Pricing"
}

struct CountryData {
    
    static let currencySymbols = [
        "USD": Symbols.dollar,
        "THB": Symbols.baht,
        "EUR": Symbols.euro,
        "JPY": Symbols.yen,
        "MXN": Symbols.dollar,
        "KRW": Symbols.won,
        "GBP": Symbols.pound,
        "GEL": Symbols.lari,
        "RUB": Symbols.ruble,
        "TRY": Symbols.lira,
        "UAH": Symbols.hryvna,
        "ILS": Symbols.shekel,
        "NGN": Symbols.naira,
        "CAD": Symbols.dollar,
        "CLP": Symbols.dollar,
        "COP": Symbols.dollar,
        "AUD": Symbols.dollar,
        "BDT": Symbols.taka,
        "CNY": Symbols.yuan,
        "HKD": Symbols.dollar,
        "INR": Symbols.rupee,
        "NZD": Symbols.dollar,
        "PHP": Symbols.peso,
        "SGD": Symbols.dollar,
        "VND": Symbols.dong,
        "BTC": Symbols.bitcoin,
        "XBT": Symbols.bitcoin
    ]
    
    static let currencyName = [
        "AED": "United Arab Emirates Dirham",
        "ANG": "Netherlands Antillean Guilder",
        "AUD": "Australian Dollar",
        "AMD": "Armenian Dram",
        "ARS": "Argentine Peso",
        "AWG": "Aruban Florin",
        "BAM": "Bosnia-Herzegovina Convertible Mark",
        "BDT": "Bangladeshi Taka",
        "BHD": "Bahraini Dinar",
        "BMD": "Bermudan Dollar",
        "BOB": "Bolivian Boliviano",
        "BRL": "Brazilian Real",
        "BSD": "Bahamian Dollar",
        "BTC": "Bitcoin",
        "BZD": "Belize Dollar",
        "CAD": "Canadian Dollar",
        "CDF": "Congolese Franc",
        "CHF": "Swiss Franc",
        "CLF": "Chilean Unit of Account (UF)",
        "CLP": "Chilean Peso",
        "CNH": "Chinese Yuan (Offshore)",
        "CNY": "Chinese Yuan",
        "COP": "Colombian Peso",
        "CRC": "Costa Rican Colón",
        "CUC": "Cuban Convertible Peso",
        "CUP": "Cuban Peso",
        "CZK": "Czech Republic Koruna",
        "DJF": "Djiboutian Franc",
        "DKK": "Danish Krone",
        "DOP": "Dominican Peso",
        "DZD": "Algerian Dinar",
        "EGP": "Egyptian Pound",
        "EUR": "Euro",
        "GTQ": "Guatemalan Quetzal",
        "AFN": "Afghan Afghani",
        "ALL": "Albanian Lek",
        "AOA": "Angolan Kwanza",
        "AZN": "Azerbaijani Manat",
        "BBD": "Barbadian Dollar",
        "BGN": "Bulgarian Lev",
        "BIF": "Burundian Franc",
        "BND": "Brunei Dollar",
        "BTN": "Bhutanese Ngultrum",
        "BWP": "Botswanan Pula",
        "BYN": "Belarusian Ruble",
        "CVE": "Cape Verdean Escudo",
        "ERN": "Eritrean Nakfa",
        "ETB": "Ethiopian Birr",
        "FJD": "Fijian Dollar",
        "FKP": "Falkland Islands Pound",
        "GBP": "British Pound Sterling",
        "GEL": "Georgian Lari",
        "GGP": "Guernsey Pound",
        "GHS": "Ghanaian Cedi",
        "GIP": "Gibraltar Pound",
        "GMD": "Gambian Dalasi",
        "GNF": "Guinean Franc",
        "GYD": "Guyanaese Dollar",
        "HKD": "Hong Kong Dollar",
        "HNL": "Honduran Lempira",
        "HRK": "Croatian Kuna",
        "HTG": "Haitian Gourde",
        "HUF": "Hungarian Forint",
        "IDR": "Indonesian Rupiah",
        "ILS": "Israeli New Sheqel",
        "IMP": "Manx pound",
        "INR": "Indian Rupee",
        "IQD": "Iraqi Dinar",
        "IRR": "Iranian Rial",
        "ISK": "Icelandic Króna",
        "JEP": "Jersey Pound",
        "JMD": "Jamaican Dollar",
        "JOD": "Jordanian Dinar",
        "JPY": "Japanese Yen",
        "KES": "Kenyan Shilling",
        "KGS": "Kyrgystani Som",
        "KHR": "Cambodian Riel",
        "KMF": "Comorian Franc",
        "KPW": "North Korean Won",
        "KRW": "South Korean Won",
        "KWD": "Kuwaiti Dinar",
        "KYD": "Cayman Islands Dollar",
        "KZT": "Kazakhstani Tenge",
        "LAK": "Laotian Kip",
        "LBP": "Lebanese Pound",
        "LKR": "Sri Lankan Rupee",
        "LRD": "Liberian Dollar",
        "LSL": "Lesotho Loti",
        "LYD": "Libyan Dinar",
        "MAD": "Moroccan Dirham",
        "MDL": "Moldovan Leu",
        "MGA": "Malagasy Ariary",
        "MKD": "Macedonian Denar",
        "MMK": "Myanma Kyat",
        "MNT": "Mongolian Tugrik",
        "MOP": "Macanese Pataca",
        "MRO": "Mauritanian Ouguiya (pre-2018)",
        "MRU": "Mauritanian Ouguiya",
        "MUR": "Mauritian Rupee",
        "MVR": "Maldivian Rufiyaa",
        "MWK": "Malawian Kwacha",
        "MXN": "Mexican Peso",
        "MYR": "Malaysian Ringgit",
        "MZN": "Mozambican Metical",
        "NAD": "Namibian Dollar",
        "NGN": "Nigerian Naira",
        "NIO": "Nicaraguan Córdoba",
        "NOK": "Norwegian Krone",
        "NPR": "Nepalese Rupee",
        "NZD": "New Zealand Dollar",
        "OMR": "Omani Rial",
        "PAB": "Panamanian Balboa",
        "PEN": "Peruvian Nuevo Sol",
        "PGK": "Papua New Guinean Kina",
        "PHP": "Philippine Peso",
        "PKR": "Pakistani Rupee",
        "PLN": "Polish Zloty",
        "PYG": "Paraguayan Guarani",
        "QAR": "Qatari Rial",
        "RON": "Romanian Leu",
        "RSD": "Serbian Dinar",
        "RUB": "Russian Ruble",
        "RWF": "Rwandan Franc",
        "SAR": "Saudi Riyal",
        "SBD": "Solomon Islands Dollar",
        "SCR": "Seychellois Rupee",
        "SDG": "Sudanese Pound",
        "SEK": "Swedish Krona",
        "SGD": "Singapore Dollar",
        "SHP": "Saint Helena Pound",
        "SLL": "Sierra Leonean Leone",
        "SOS": "Somali Shilling",
        "SRD": "Surinamese Dollar",
        "SSP": "South Sudanese Pound",
        "STD": "São Tomé and Príncipe Dobra (pre-2018)",
        "STN": "São Tomé and Príncipe Dobra",
        "SVC": "Salvadoran Colón",
        "SYP": "Syrian Pound",
        "SZL": "Swazi Lilangeni",
        "THB": "Thai Baht",
        "TJS": "Tajikistani Somoni",
        "TMT": "Turkmenistani Manat",
        "TND": "Tunisian Dinar",
        "TOP": "Tongan Pa'anga",
        "TRY": "Turkish Lira",
        "TTD": "Trinidad and Tobago Dollar",
        "TWD": "New Taiwan Dollar",
        "TZS": "Tanzanian Shilling",
        "UAH": "Ukrainian Hryvnia",
        "UGX": "Ugandan Shilling",
        "USD": "United States Dollar",
        "UYU": "Uruguayan Peso",
        "UZS": "Uzbekistan Som",
        "VEF": "Venezuelan Bolívar Fuerte (Old)",
        "VES": "Venezuelan Bolívar Soberano",
        "VND": "Vietnamese Dong",
        "VUV": "Vanuatu Vatu",
        "WST": "Samoan Tala",
        "XAF": "CFA Franc BEAC",
        "XAG": "Silver Ounce",
        "XAU": "Gold Ounce",
        "XCD": "East Caribbean Dollar",
        "XDR": "Special Drawing Rights",
        "XOF": "CFA Franc BCEAO",
        "XPD": "Palladium Ounce",
        "XPF": "CFP Franc",
        "XPT": "Platinum Ounce",
        "YER": "Yemeni Rial",
        "ZAR": "South African Rand",
        "ZMW": "Zambian Kwacha",
        "ZWL": "Zimbabwean Dollar"
    ]
}
