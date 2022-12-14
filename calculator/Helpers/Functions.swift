//
//  Functions.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/11/22.
//

import Foundation

struct Functions {
    
    static let formulas: [FormulaUnit] = [
        FormulaUnit(title: "Monthly Loan Payment", formula: "(?a*(?c/12))/(1-((1+(?c/12))**(?b*-1)))", category: Categories.financial, symbol: "PMT", inputCues: ["Amount to be borrowed?", "Length of Loan (Months)?", "Interest Rate APR (i.e. 0.065)?"], favorite: nil, answerPrefix: "The payment for that loan amount, length and APR will be", answerSuffix: "/mo"),
        FormulaUnit(title: "Monthly Mortgage Payment (30-year)", formula: "((?a-?b)*(?c/12))/(1-((1+(?c/12))**-360))+?d/12+?e/12+?f", category: Categories.financial, symbol: "MORT", inputCues: ["What is the price of the property?","What is the down payment amount?", "Loan's interest rate APR (i.e. 0.065)?", "Annual property taxes?", "Annual homeowners insurance?","Monthly home association fee?"], favorite: nil, answerPrefix: "The 30-year mortgage payment will be", answerSuffix: "/mo"),
        FormulaUnit(title: "Miles per Gallon", formula: "?a/?b", category: Categories.automotive, symbol: "MPG", inputCues: ["Miles Traveled?", "Gallons of Fuel Consumed?"], favorite: nil, answerPrefix: nil, answerSuffix: " mpg"),
        FormulaUnit(title: "Kilometers per Liter", formula: "?a/?b", category: Categories.automotive, symbol: "KPG", inputCues: ["Kilometers Traveled?", "Liters of Fuel Consumed?"], favorite: nil, answerPrefix: nil, answerSuffix: "KPG"),
        FormulaUnit(title: "Time to Destination", formula: "?a/?b\(Symbols.hourglass)", category: Categories.automotive, symbol: "TtoD", inputCues: ["Distance to destination?", "Speed?"], favorite: nil, answerPrefix: "Time to Dest. ", answerSuffix: nil),
        FormulaUnit(title: "Annual Salary", formula: "?a*2080", category: Categories.financial, symbol: "Salary", inputCues: ["Hourly rate?"], favorite: nil, answerPrefix: nil, answerSuffix: "/yr"),
        FormulaUnit(title: "Future Value - Compounding Interest", formula: "?a*(1+?c/12)**?b", category: Categories.financial, symbol: "FV(Ci)", inputCues: ["Amount invested?", "Length of investment (Months)?", "Enter interest APR (i.e. 0.05)?"], favorite: nil, answerPrefix: "FV ", answerSuffix: nil),
        FormulaUnit(title: "TIP - Gratuity Amount", formula: "?a*?b", category: Categories.financial, symbol: "TIP", inputCues: ["Bill Amount (before taxes)?", "Tip percentage (i.e. 0.18)?"], favorite: nil, answerPrefix: "Tip ", answerSuffix: nil),
        FormulaUnit(title: "Body Mass Index (Standard)", formula: "(?b * 703)/(?a**2)", category: Categories.health, symbol: "BMI(std)", inputCues: ["Height(in)?", "Weight(lb)?"], favorite: nil, answerPrefix: "BMI ", answerSuffix: nil),
        FormulaUnit(title: "Body Mass Index (Metric)", formula: "(?b)/(?a**2)", category: Categories.health, symbol: "BMI(SI)", inputCues: ["Height(m)?", "Weight(kg)?"], favorite: nil, answerPrefix: "BMI ", answerSuffix: nil),
        FormulaUnit(title: "Airport Density Altitude", formula: "?a + (120 * (?b - (15 - 2 * ?a/1000)))", category: Categories.aviation, symbol: "DALT", inputCues: ["Airport's elevation?", "Outside air temperature (\(Symbols.celsius))?"], favorite: nil, answerPrefix: "DALT ", answerSuffix: "'"),
        FormulaUnit(title: "Maximum HoldingTime", formula: "(?a - (?b + (?c * ?d))) / ?c\(Symbols.hourglass)", category: Categories.aviation, symbol: "Hold-T", inputCues:  ["Fuel onboard when entering hold?", "Reserve fuel required/desired?", "Fuel burn to the alternate airport?", "Total time to alternate(s) (include approach times)"], favorite: nil, answerPrefix: "Max Hold ", answerSuffix: nil),
        FormulaUnit(title: "Bingo Fuel", formula: "?a + ?b * (?c + ?d)", category: Categories.aviation, symbol: "B-FUEL", inputCues: ["Reserve required/desired?", "Fuel burn (per hour)?", "Time to destination airport (including the approach and missed time)?", "Time to alternates(s)"], favorite: nil, answerPrefix: "Bingo Fuel ", answerSuffix: nil),
        FormulaUnit(title: "Rate of Descent", formula: "?b / 60 * 6076.12 * function(?a, 'tangent')", category: Categories.aviation, symbol: "ROD", inputCues:  ["Desired glidepath angle (deg)?", "Aircraft's groundspeed (Knots)?"], favorite: nil, answerPrefix: nil, answerSuffix: " fpm"),
        FormulaUnit(title: "Top of descent (dist)", formula: "((?b - ?c) / function(?a, 'tangent')) / 6076.12", category: Categories.aviation, symbol: "TOD (d)", inputCues: ["Desired glidepath angle (deg)? >", "Aircraft's altitude (ft)?>", "Destination field's elevation (ft)?>"], favorite: nil, answerPrefix: "TOD ", answerSuffix: "nm"),
        FormulaUnit(title: "Voltage", formula: "?a/?b", category: Categories.electronics, symbol: "Volts(E)", inputCues: ["Power (Watts)?", "Current (amps)?"], favorite: nil, answerPrefix: nil, answerSuffix: " volts"),
        FormulaUnit(title: "Current (Amps)", formula: "?a/?b", category: Categories.electronics, symbol: "Amps(I)", inputCues: ["Power (Watts)?", "Volts?"], favorite: nil, answerPrefix: nil, answerSuffix: " amps"),
        FormulaUnit(title: "Power (Watts)", formula: "?a*?b", category: Categories.electronics, symbol: "Power(P)", inputCues: ["Volts?", "Current (Amps)?" ], favorite: nil, answerPrefix: nil, answerSuffix: " watts"),
        FormulaUnit(title: "Tangent(degrees)", formula: "function(?a, 'tangent')", category: Categories.trig, symbol: "Tan", inputCues: ["Angle (degrees)?"], favorite: nil, answerPrefix: "Tan ", answerSuffix: nil),
        FormulaUnit(title: "Sine (degrees)", formula: "function(?a, 'sinus')", category: Categories.trig, symbol: "Sin", inputCues: ["Angle (degrees)?"], favorite: nil, answerPrefix: "Sin ", answerSuffix: nil),
        FormulaUnit(title: "Cosine (degrees)", formula: "function(?a, 'cosine')", category: Categories.trig, symbol: "Cos", inputCues: ["Angle (degrees)?"], favorite: nil, answerPrefix: "Cos ", answerSuffix: nil),
        FormulaUnit(title: "Volume of concrete slab", formula: "?a * ?b * (?c / 12) / 27", category: Categories.construction, symbol: "SLAB", inputCues: ["Slab length (feet)?", "Slab width (feet)?", "Slab thickness (inches)?"], favorite: nil, answerPrefix: "Volume ", answerSuffix: " yd??"),
        FormulaUnit(title: "Volume of concrete footings", formula: "((?a / 12) * (?b / 12) * ?c) / 27", category: Categories.construction, symbol: "FTGS", inputCues: ["Footing depth (feet)?", "Footing width (feet)?", "Footing length (inches)?"], favorite: nil, answerPrefix: "Volume ", answerSuffix: " yd??"),
        FormulaUnit(title: "Volume of concrete column", formula: "(([Pi] * ((?a/36)**2)) * (?b/36))", category: Categories.construction, symbol: "CLMNS", inputCues: ["Column diameter (inches)?", "Column height (inches)?"], favorite: nil, answerPrefix: "Volume ", answerSuffix: " yd??"),
        FormulaUnit(title: "Speed of Sound", formula: "(643.855 * (( ?a + 273.15) / 273.15 )**0.5)", category: Categories.aviation, symbol: "Vsound", inputCues: ["Temperature (\(Symbols.celsius))?"], favorite: nil, answerPrefix: nil, answerSuffix: " kt"),
        FormulaUnit(title: "MACH Number", formula: "?a / (643.855 * ((?b + 273.15) / 273.15)**0.5)", category: Categories.aviation, symbol: "MACH#", inputCues: ["TAS (kt)?","Temperature (\(Symbols.celsius))?"], favorite: nil, answerPrefix: nil, answerSuffix: " Mach"),
        FormulaUnit(title: "Crosswind", formula: "abs(function((360 - ?a * 10) - (360 - ?b), 'sinus') * ?c)", category: Categories.aviation, symbol: "XWIND", inputCues: ["Runway Number?", "Wind Direction (ie 40)?", "Wind Speed (kts)"], favorite: nil, answerPrefix: nil, answerSuffix: " kt")
    ]
        
    static let conversions: [ConversionUnit] = [
        ConversionUnit(title: "Centimeter", multiplier: 0.01, category: Categories.length, symbol: "cm", favorite: nil, answerPrefix: nil, answerSuffix: " cm"),
        ConversionUnit(title: "Decimeter", multiplier: 0.1, category: Categories.length, symbol: "dm", favorite: nil, answerPrefix: nil, answerSuffix: " dm"),
        ConversionUnit(title: "Foot", multiplier: 0.3048, category: Categories.length, symbol: "ft", favorite: nil, answerPrefix: nil, answerSuffix: " ft"),
        ConversionUnit(title: "Inch", multiplier: 0.0254, category: Categories.length, symbol: "in", favorite: nil, answerPrefix: nil, answerSuffix: " in"),
        ConversionUnit(title: "Kilometer", multiplier: 1000, category: Categories.length, symbol: "km", favorite: nil, answerPrefix: nil, answerSuffix: " km"),
        ConversionUnit(title: "Meter", multiplier: 1.0, category: Categories.length, symbol: "m", favorite: nil, answerPrefix: nil, answerSuffix: " m"),
        ConversionUnit(title: "Fathom", multiplier: 1.8288036576, category: Categories.length, symbol: "fath", favorite: nil, answerPrefix: nil, answerSuffix: " fath"),
        ConversionUnit(title: "Micrometer", multiplier: 0.000001, category: Categories.length, symbol: "??m", favorite: nil, answerPrefix: nil, answerSuffix: " ??m"),
        ConversionUnit(title: "Millimeter", multiplier: 0.001, category: Categories.length, symbol: "mm", favorite: nil, answerPrefix: nil, answerSuffix: "mm"),
        ConversionUnit(title: "Nanometer", multiplier: 0.000000001, category: Categories.length, symbol: "nm", favorite: nil, answerPrefix: nil, answerSuffix: " nm"),
        ConversionUnit(title: "Nautical Mile", multiplier: 1852, category: Categories.length, symbol: "NM", favorite: nil, answerPrefix: nil, answerSuffix: " NM"),
        ConversionUnit(title: "U.S. Mile", multiplier: 1609.344, category: Categories.length, symbol: "mi", favorite: nil, answerPrefix: nil, answerSuffix: " mi"),
        ConversionUnit(title: "Yard", multiplier: 0.9144, category: Categories.length, symbol: "yd", favorite: nil, answerPrefix: nil, answerSuffix: " yd"),
        ConversionUnit(title: "Gigameter", multiplier: 1000000000, category: Categories.length, symbol: "Gm", favorite: nil, answerPrefix: nil, answerSuffix: " Gm"),
        ConversionUnit(title: "Megameter", multiplier: 1000000, category: Categories.length, symbol: "Mm", favorite: nil, answerPrefix: nil, answerSuffix: " Mm"),
        ConversionUnit(title: "Hectometer", multiplier: 100, category: Categories.length, symbol: "hm", favorite: nil, answerPrefix: nil, answerSuffix: " hm"),
        ConversionUnit(title: "Dekameter", multiplier: 10, category: Categories.length, symbol: "dam", favorite: nil, answerPrefix: nil, answerSuffix: " dam"),
        ConversionUnit(title: "Micron", multiplier: 0.000001, category: Categories.length, symbol: "??", favorite: nil, answerPrefix: nil, answerSuffix: " ??"),
        ConversionUnit(title: "League", multiplier: 4828.032, category: Categories.length, symbol: "lea", favorite: nil, answerPrefix: nil, answerSuffix: " lea"),
        ConversionUnit(title: "Kiloyard", multiplier: 914.4, category: Categories.length, symbol: "kyd", favorite: nil, answerPrefix: nil, answerSuffix: " kyd"),
        ConversionUnit(title: "Fulong", multiplier: 201.16840234, category: Categories.length, symbol: "fur", favorite: nil, answerPrefix: nil, answerSuffix: " fur"),
        ConversionUnit(title: "Rod", multiplier: 5.0292100584, category: Categories.length, symbol: "rd", favorite: nil, answerPrefix: nil, answerSuffix: " rd"),
        ConversionUnit(title: "Carat", multiplier: 0.2, category: Categories.mass, symbol: "ct", favorite: nil, answerPrefix: nil, answerSuffix: " ct"),
        ConversionUnit(title: "Pennyweight", multiplier: 1.55517384, category: Categories.mass, symbol: "pwt", favorite: nil, answerPrefix: nil, answerSuffix: " pwt"),
        ConversionUnit(title: "Gram", multiplier: 1.0, category: Categories.mass, symbol: "g", favorite: nil, answerPrefix: nil, answerSuffix: " g"),
        ConversionUnit(title: "Kilogram", multiplier: 1000.0, category: Categories.mass, symbol: "kg", favorite: nil, answerPrefix: nil, answerSuffix: " kg"),
        ConversionUnit(title: "U.S. Pound", multiplier: 453.592, category: Categories.mass, symbol: "lb", favorite: nil, answerPrefix: nil, answerSuffix: " lb"),
        ConversionUnit(title: "U.S. Ounce", multiplier: 28.3495, category: Categories.mass, symbol: "oz", favorite: nil, answerPrefix: nil, answerSuffix: " oz"),
        ConversionUnit(title: "Troy Pound", multiplier: 373.24, category: Categories.mass, symbol: "lb t", favorite: nil, answerPrefix: nil, answerSuffix: " lb t"),
        ConversionUnit(title: "Milligram", multiplier: 0.001, category: Categories.mass, symbol: "mg", favorite: nil, answerPrefix: nil, answerSuffix: " mg"),
        ConversionUnit(title: "Troy Ounce", multiplier: 31.1035, category: Categories.mass, symbol: "oz t", favorite: nil, answerPrefix: nil, answerSuffix: " oz t"),
        ConversionUnit(title: "British Stone", multiplier: 6350.29, category: Categories.mass, symbol: "st", favorite: nil, answerPrefix: nil, answerSuffix: " st"),
        ConversionUnit(title: "U.S. Short Ton", multiplier: 907185.0, category: Categories.mass, symbol: "t", favorite: nil, answerPrefix: nil, answerSuffix: " ton"),
        ConversionUnit(title: "Metric Ton", multiplier: 1000000, category: Categories.mass, symbol: "ton(m)", favorite: nil, answerPrefix: nil, answerSuffix: " ton(m)"),
        ConversionUnit(title: "U.K. Long Ton", multiplier: 1016046.9088, category: Categories.mass, symbol: "ton(UK)", favorite: nil, answerPrefix: nil, answerSuffix: " ton(UK)"),
        ConversionUnit(title: "Megagram", multiplier: 1000000, category: Categories.mass, symbol: "Mg", favorite: nil, answerPrefix: nil, answerSuffix: " Mg"),
        ConversionUnit(title: "Hectogram", multiplier: 100, category: Categories.mass, symbol: "hg", favorite: nil, answerPrefix: nil, answerSuffix: " hg"),
        ConversionUnit(title: "Dekagram", multiplier: 10, category: Categories.mass, symbol: "dag", favorite: nil, answerPrefix: nil, answerSuffix: " dag"),
        ConversionUnit(title: "Decigram", multiplier: 0.1, category: Categories.mass, symbol: "dg", favorite: nil, answerPrefix: nil, answerSuffix: " dg"),
        ConversionUnit(title: "Centigram", multiplier: 0.01, category: Categories.mass, symbol: "cg", favorite: nil, answerPrefix: nil, answerSuffix: " cg"),
        ConversionUnit(title: "Microgram", multiplier: 0.000001, category: Categories.mass, symbol: "??g", favorite: nil, answerPrefix: nil, answerSuffix: " ??g"),
        ConversionUnit(title: "Kilometer per Hour", multiplier: 0.2777777778, category: Categories.velocity, symbol: "kmh", favorite: nil, answerPrefix: nil, answerSuffix: " kmh"),
        ConversionUnit(title: "Mile per Second", multiplier: 1609.344, category: Categories.velocity, symbol: "mi/s", favorite: nil, answerPrefix: nil, answerSuffix: " mi/s"),
        ConversionUnit(title: "Mile per Hour", multiplier: 0.44704, category: Categories.velocity, symbol: "mph", favorite: nil, answerPrefix: nil, answerSuffix: " mph"),
        ConversionUnit(title: "Mile per Minute", multiplier: 26.8224, category: Categories.velocity, symbol: "mi/m", favorite: nil, answerPrefix: nil, answerSuffix: " mi/m"),
        ConversionUnit(title: "Meter per Second", multiplier: 1.0, category: Categories.velocity, symbol: "m/s", favorite: nil, answerPrefix: nil, answerSuffix: " m/s"),
        ConversionUnit(title: "Nautical Mile per Hour", multiplier: 0.5144444444, category: Categories.velocity, symbol: "kt", favorite: nil, answerPrefix: nil, answerSuffix: " kt"),
        ConversionUnit(title: "Mach", multiplier: 295.0464, category: Categories.velocity, symbol: "M", favorite: nil, answerPrefix: nil, answerSuffix: " M"),
        ConversionUnit(title: "Meter per Hour", multiplier: 0.0002777778, category: Categories.velocity, symbol: "m/h", favorite: nil, answerPrefix: nil, answerSuffix: " m/h"),
        ConversionUnit(title: "Meter per Minute", multiplier: 0.0166666667, category: Categories.velocity, symbol: "m/min", favorite: nil, answerPrefix: nil, answerSuffix: " m/min"),
        ConversionUnit(title: "Kilometer per Minute", multiplier: 16.666666667, category: Categories.velocity, symbol: "km/min", favorite: nil, answerPrefix: nil, answerSuffix: " km/min"),
        ConversionUnit(title: "Kilometer per Second", multiplier: 1000, category: Categories.velocity, symbol: "km/s", favorite: nil, answerPrefix: nil, answerSuffix: " km/s"),
        ConversionUnit(title: "Centimeter per Hour", multiplier: 0.0000027778, category: Categories.velocity, symbol: "cm/h", favorite: nil, answerPrefix: nil, answerSuffix: " cm/h"),
        ConversionUnit(title: "Foot per Hour", multiplier: 0.0000846667, category: Categories.velocity, symbol: "ft/h", favorite: nil, answerPrefix: nil, answerSuffix: " ft/h"),
        ConversionUnit(title: "Foot per Minute", multiplier: 0.00508, category: Categories.velocity, symbol: "ft/m", favorite: nil, answerPrefix: nil, answerSuffix: " ft/m"),
        ConversionUnit(title: "Foot per Second", multiplier: 0.3048, category: Categories.velocity, symbol: "ft/s", favorite: nil, answerPrefix: nil, answerSuffix: " ft/s"),
        ConversionUnit(title: "Celsius", multiplier: nil, category: Categories.temperature, symbol: String(Symbols.celsius), favorite: nil, answerPrefix: nil, answerSuffix: String(Symbols.celsius)),
        ConversionUnit(title: "Fahrenheit", multiplier: nil, category: Categories.temperature, symbol: String(Symbols.fahrenheit), favorite: nil, answerPrefix: nil, answerSuffix: String(Symbols.fahrenheit)),
        ConversionUnit(title: "Kelvin", multiplier: nil, category: Categories.temperature, symbol: String(Symbols.kelvin), favorite: nil, answerPrefix: nil, answerSuffix: String(Symbols.kelvin)),
        ConversionUnit(title: "Square Kilometer", multiplier: 1000000, category: Categories.area, symbol: "km??", favorite: nil, answerPrefix: nil, answerSuffix: " km??"),
        ConversionUnit(title: "Square Centimeter", multiplier: 0.0001, category: Categories.area, symbol: "cm??", favorite: nil, answerPrefix: nil, answerSuffix: " cm??"),
        ConversionUnit(title: "Square Millimeter", multiplier: 0.000001, category: Categories.area, symbol: "mm??", favorite: nil, answerPrefix: nil, answerSuffix: " mm??"),
        ConversionUnit(title: "Square Micrometer", multiplier: 0.0000000000010, category: Categories.area, symbol: "mm??", favorite: nil, answerPrefix: nil, answerSuffix: " ??m??"),
        ConversionUnit(title: "Square Meter", multiplier: 1.0, category: Categories.area, symbol: "m??", favorite: nil, answerPrefix: nil, answerSuffix: " m??"),
        ConversionUnit(title: "Hectare", multiplier: 10000.00, category: Categories.area, symbol: "ha", favorite: nil, answerPrefix: nil, answerSuffix: " ha"),
        ConversionUnit(title: "Acre", multiplier: 4046.8564224, category: Categories.area, symbol: "ac", favorite: nil, answerPrefix: nil, answerSuffix: " ac"),
        ConversionUnit(title: "Square Mile", multiplier: 2589998.4703, category: Categories.area, symbol: "mi??", favorite: nil, answerPrefix: nil, answerSuffix: " mi??"),
        ConversionUnit(title: "Square Yard", multiplier: 0.83612736, category: Categories.area, symbol: "yd??", favorite: nil, answerPrefix: nil, answerSuffix: " yd??"),
        ConversionUnit(title: "Square Foot", multiplier: 0.0929034116, category: Categories.area, symbol: "ft??", favorite: nil, answerPrefix: nil, answerSuffix: " ft??"),
        ConversionUnit(title: "Square Inch", multiplier: 0.00064516, category: Categories.area, symbol: "in??", favorite: nil, answerPrefix: nil, answerSuffix: " in??"),
        ConversionUnit(title: "Square Hectometer", multiplier: 10000, category: Categories.area, symbol: "hm??", favorite: nil, answerPrefix: nil, answerSuffix: " hm??"),
        ConversionUnit(title: "Square Dekameter", multiplier: 100, category: Categories.area, symbol: "dam??", favorite: nil, answerPrefix: nil, answerSuffix: " dam??"),
        ConversionUnit(title: "Square Decimeter", multiplier: 0.01, category: Categories.area, symbol: "dm??", favorite: nil, answerPrefix: nil, answerSuffix: " dm??"),
        ConversionUnit(title: "Square Rod", multiplier: 25.292953812, category: Categories.area, symbol: "rd??", favorite: nil, answerPrefix: nil, answerSuffix: " rd??"),
        ConversionUnit(title: "U.S. Cup", multiplier: 0.2365882365, category: Categories.volume, symbol: "cup", favorite: nil, answerPrefix: nil, answerSuffix: " cp"),
        ConversionUnit(title: "U.S. Gallon", multiplier: 3.785411784, category: Categories.volume, symbol: "gal", favorite: nil, answerPrefix: nil, answerSuffix: " gal"),
        ConversionUnit(title: "U.S. Quart", multiplier: 0.946352946, category: Categories.volume, symbol: "qt", favorite: nil, answerPrefix: nil, answerSuffix: " qt"),
        ConversionUnit(title: "U.S. Pint", multiplier: 0.473176473, category: Categories.volume, symbol: "pt", favorite: nil, answerPrefix: nil, answerSuffix: " pt"),
        ConversionUnit(title: "U.S. Fluid Oz", multiplier: 0.0295735296, category: Categories.volume, symbol: "flOz", favorite: nil, answerPrefix: nil, answerSuffix: " flOz"),
        ConversionUnit(title: "U.S. Tablespoon", multiplier: 0.0147867648, category: Categories.volume, symbol: "Tbsp", favorite: nil, answerPrefix: nil, answerSuffix: " Tbsp"),
        ConversionUnit(title: "U.S. Teaspoon", multiplier: 0.0049289216, category: Categories.volume, symbol: "tsp", favorite: nil, answerPrefix: nil, answerSuffix: " tsp"),
        ConversionUnit(title: "Cubic Meter", multiplier: 1000, category: Categories.volume, symbol: "cm??", favorite: nil, answerPrefix: nil, answerSuffix: " cm??"),
        ConversionUnit(title: "Liter", multiplier: 1, category: Categories.volume, symbol: "L", favorite: nil, answerPrefix: nil, answerSuffix: " L"),
        ConversionUnit(title: "Pound - Jet Fuel", multiplier: 0.5683, category: Categories.volume, symbol: "JP#", favorite: nil, answerPrefix: nil, answerSuffix: " lb"),
        ConversionUnit(title: "Pound - AVGas", multiplier: 0.628805945, category: Categories.volume, symbol: "AV#", favorite: nil, answerPrefix: nil, answerSuffix: " lb"),
        ConversionUnit(title: "Milliliter", multiplier: 0.001, category: Categories.volume, symbol: "mL", favorite: nil, answerPrefix: nil, answerSuffix: " mL"),
        ConversionUnit(title: "Cubic Yard", multiplier: 764.55485798, category: Categories.volume, symbol: "yd??", favorite: nil, answerPrefix: nil, answerSuffix: " yd??"),
        ConversionUnit(title: "Cubic Foot", multiplier: 28.316846592, category: Categories.volume, symbol: "ft??", favorite: nil, answerPrefix: nil, answerSuffix: " ft??"),
        ConversionUnit(title: "Cubic Inch", multiplier: 0.016387064, category: Categories.volume, symbol: "in??", favorite: nil, answerPrefix: nil, answerSuffix: " in??"),
        ConversionUnit(title: "Cubic Kilometer", multiplier: 1000000000000, category: Categories.volume, symbol: "km??", favorite: nil, answerPrefix: nil, answerSuffix: " km??"),
        ConversionUnit(title: "Cubic Millimeter", multiplier: 0.000001, category: Categories.volume, symbol: "mm??", favorite: nil, answerPrefix: nil, answerSuffix: " mm??"),
        ConversionUnit(title: "Cubic Mile", multiplier: 4168181825441, category: Categories.volume, symbol: "mi??", favorite: nil, answerPrefix: nil, answerSuffix: " mi??"),
        ConversionUnit(title: "Cubic Decimeter", multiplier: 1, category: Categories.volume, symbol: "dm??", favorite: nil, answerPrefix: nil, answerSuffix: " dm??"),
        ConversionUnit(title: "Hectoliter", multiplier: 100, category: Categories.volume, symbol: "hL", favorite: nil, answerPrefix: nil, answerSuffix: " hL"),
        ConversionUnit(title: "Dekaliter", multiplier: 10, category: Categories.volume, symbol: "daL", favorite: nil, answerPrefix: nil, answerSuffix: " daL"),
        ConversionUnit(title: "Deciliter", multiplier: 0.1, category: Categories.volume, symbol: "dL", favorite: nil, answerPrefix: nil, answerSuffix: " dL"),
        ConversionUnit(title: "Centiliter", multiplier: 0.01, category: Categories.volume, symbol: "cL", favorite: nil, answerPrefix: nil, answerSuffix: " cL"),
        ConversionUnit(title: "Micoliter", multiplier: 0.000001, category: Categories.volume, symbol: "??L", favorite: nil, answerPrefix: nil, answerSuffix: " ??L"),
        ConversionUnit(title: "Cubic Centimeter", multiplier: 0.001, category: Categories.volume, symbol: "cm??", favorite: nil, answerPrefix: nil, answerSuffix: " cm??"),
        ConversionUnit(title: "Newton", multiplier: 1, category: Categories.force, symbol: "N", favorite: nil, answerPrefix: nil, answerSuffix: " N"),
        ConversionUnit(title: "Kilonewton", multiplier: 1000, category: Categories.force, symbol: "kN", favorite: nil, answerPrefix: nil, answerSuffix: " kN"),
        ConversionUnit(title: "Gram-Force", multiplier: 0.00980665, category: Categories.force, symbol: "gf", favorite: nil, answerPrefix: nil, answerSuffix: " gf"),
        ConversionUnit(title: "Kilogram-Force", multiplier: 9.80665, category: Categories.force, symbol: "kgf", favorite: nil, answerPrefix: nil, answerSuffix: " kgf"),
        ConversionUnit(title: "Ton-Force (metric)", multiplier: 9806.65, category: Categories.force, symbol: "tf", favorite: nil, answerPrefix: nil, answerSuffix: " tf"),
        ConversionUnit(title: "Meganewton", multiplier: 1000000, category: Categories.force, symbol: "MN", favorite: nil, answerPrefix: nil, answerSuffix: " MN"),
        ConversionUnit(title: "Hectonewton", multiplier: 100, category: Categories.force, symbol: "hN", favorite: nil, answerPrefix: nil, answerSuffix: " hN"),
        ConversionUnit(title: "Dekanewton", multiplier: 10, category: Categories.force, symbol: "daN", favorite: nil, answerPrefix: nil, answerSuffix: " daN"),
        ConversionUnit(title: "Decinewton", multiplier: 0.1, category: Categories.force, symbol: "dN", favorite: nil, answerPrefix: nil, answerSuffix: " dN"),
        ConversionUnit(title: "Centinewton", multiplier: 0.01, category: Categories.force, symbol: "cN", favorite: nil, answerPrefix: nil, answerSuffix: " cN"),
        ConversionUnit(title: "Millinewton", multiplier: 0.001, category: Categories.force, symbol: "mN", favorite: nil, answerPrefix: nil, answerSuffix: " mN"),
        ConversionUnit(title: "Micronewton", multiplier: 0.000001, category: Categories.force, symbol: "??N", favorite: nil, answerPrefix: nil, answerSuffix: " ??N"),
        ConversionUnit(title: "Dyne", multiplier: 0.00001, category: Categories.force, symbol: "dyn", favorite: nil, answerPrefix: nil, answerSuffix: " dyn"),
        ConversionUnit(title: "Joule/Meter", multiplier: 1, category: Categories.force, symbol: "J/m", favorite: nil, answerPrefix: nil, answerSuffix: " J/m"),
        ConversionUnit(title: "Joule/Centimeter", multiplier: 0.01, category: Categories.force, symbol: "J/cm", favorite: nil, answerPrefix: nil, answerSuffix: " J/cm"),
        ConversionUnit(title: "Ton-Force (short)", multiplier: 8896.4432305, category: Categories.force, symbol: "tf(s)", favorite: nil, answerPrefix: nil, answerSuffix: " tf(s)"),
        ConversionUnit(title: "Ton-Force (long)", multiplier: 9964.0164182, category: Categories.force, symbol: "tf(l)", favorite: nil, answerPrefix: nil, answerSuffix: " tf(l)"),
        ConversionUnit(title: "Pound-Force", multiplier: 4.4482216153, category: Categories.force, symbol: "lbf", favorite: nil, answerPrefix: nil, answerSuffix: " lbf"),
        ConversionUnit(title: "Ounce-Force", multiplier: 0.278013851, category: Categories.force, symbol: "ozf", favorite: nil, answerPrefix: nil, answerSuffix: " ozf")
    ]
    
    static var conversionList: [[FunctionData]] {
        
        let conversions = Functions.conversions
        var list:[[FunctionData]] = [[]]
        
        for (index, conversion) in conversions.enumerated() {

            // if the very first conversion, then
            if index == 0 {
                var group:[FunctionData] = []
                group.append(FunctionData(category: conversion.category!, title: conversion.title!, symbol: conversion.symbol!))
                list[0] = group
            }
            else {
                
                var createNewSection = true
                
                for (index, section) in list.enumerated() {
                    if !section.isEmpty && section[0].category == conversion.category {
                        list[index].append(FunctionData(category: conversion.category!, title: conversion.title!, symbol: conversion.symbol!))
                        createNewSection = false
                    }
                }
                if createNewSection {
                    var group:[FunctionData] = []
                    group.append(FunctionData(category: conversion.category!, title: conversion.title!, symbol: conversion.symbol!))
                    list.append(group)
                }
            }
        }
        
        return list
    }
    
    static var formulaList: [[FunctionData]] {
        
        let formulas = Functions.formulas
        var list:[[FunctionData]] = [[]]
        
        for (index, formula) in formulas.enumerated() {

            // if the very first formula, then
            if index == 0 {
                var group:[FunctionData] = []
                group.append(FunctionData(category: formula.category!, title: formula.title!, symbol: formula.symbol!))
                list[0] = group
            }
            else {
                
                var createNewSection = true
                
                for (index, section) in list.enumerated() {
                    if !section.isEmpty && section[0].category == formula.category {
                        list[index].append(FunctionData(category: formula.category!, title: formula.title!, symbol: formula.symbol!))
                        createNewSection = false
                    }
                }
                if createNewSection {
                    var group:[FunctionData] = []
                    group.append(FunctionData(category: formula.category!, title: formula.title!, symbol: formula.symbol!))
                    list.append(group)
                }
            }
        }
        
        return list
    }

}
