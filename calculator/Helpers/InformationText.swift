//
//  InformationText.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/10/22.
//

import UIKit

struct InformationText {
    
    static var copyrightText: NSMutableAttributedString {
        let titleText               = "FunctionCalc"
        let copyRightText           = Constants.appCopyright
        let textString              = "\n\(titleText)\n\(copyRightText)"
        let titleRange              = (textString as NSString).range(of: titleText)
        let copyRightRange          = (textString as NSString).range(of: copyRightText)
        let attrText                = NSMutableAttributedString(string: textString)
        let paragraph               = NSMutableParagraphStyle()
        paragraph.alignment         = .center
        attrText.addAttribute(.paragraphStyle, value: paragraph, range: titleRange)
        attrText.addAttribute(.paragraphStyle, value: paragraph, range: copyRightRange)
        
        let titleFont               = Fonts.titleMoreInfo
        let copyRightFont           = Fonts.copyright
        attrText.addAttribute(.font, value: titleFont, range: titleRange)
        attrText.addAttribute(.font, value: copyRightFont, range: copyRightRange )

        return attrText
    }

    
    static var instructions: NSMutableAttributedString {
        
        let favAttachment           = NSTextAttachment()
        favAttachment.image         = ImageSymbols.favoriteStar?.withTintColor(.link)
        
        let fxAttachment            = NSTextAttachment()
        fxAttachment.image          = ImageSymbols.functionSym?.withTintColor(.link)
        
        let filledStar              = NSAttributedString(attachment: favAttachment)
        
        let favoriteStar            = "[STAR]"
        let hyperLinkText           = "FunctionCalc website"
        let mailToLinkText          = "pat@LawlerInnovationsInc.com"
        let subTitleText            = "Overview of Functions"
        let header0                 = "The additional functions include:"
        let bulletPoints            = """
        • Performs calculations in time format (great for aviators calculating flight-times!)
        • Thousands of direct conversions for units such as currencies, mass/weights, volumes, temperature etc.
        • Pre-programmed complex mathematical formulas with text prompts, for user-friendly data input
        • Customizable buttons which allow for one-tap access to the built-in formulas and conversions
        • Up to date currency exchange rates for more than 165 currencies; including precious metals and cryptocurrencies
        """
        let header1                 = "Time Format"
        let header2                 = "Pre-Loaded Conversions"
        let header3                 = "Pre-Loaded Formulas"
        let header4                 = "Real-Time Exchange Rates"
        let header5                 = "Preset Buttons"
        let aviationDisclaimerText  = """
                Note: The Aviation functions are based on "Rule-Of-Thumb" estimates and should never be used as a primary flight planning tool, they should only be used For Reference Only.
                """
        let bodyText                = """
        
        
        
            Thank you very much for checking out the FunctionCalc app!
            
            Although FunctionCalc is a very simple calculator, it provides some additional functionality that makes it very useful for everyday uses. Some of these additional functions include:
        
        \(bulletPoints)
        
            FunctionCalc has been found to be especially beneficial for those traveling to foreign countries that use different monetary and measurement systems. Keeping the country's currency and measurement conversions in the preset buttons allows for one-tap conversion to the user's own familiar units, even if the phone's access to the Internet is shut-off, the calculator will continue converting the currencies to the last downloaded rates.

            Additional formulas and conversions will be added in subsequent updates. If there are any specific functions, such as formulas or conversions, that you would like to see added, please contact the developer directly at \(mailToLinkText) and we will try to implement your requests in one of the upcoming updates.
        
            Please visit the \(hyperLinkText) for more information.
        
        
        \(subTitleText)
        
        \(header1)
            In addition to performing "regular" calculator operation, FunctionCalc also performs mathematic operations on time-formatted numbers such as "3:45".  For example, calculations may be made exclusively in time-format, where the result will be displayed as time (3:45 + 1:29 = 5:14).
        
            Likewise, a time formatted number may also be used along with a decimal number (i.e. 48:15 x 15). The result will be displayed in time format (from the previous example = 723:45). However, long-pressing the ":" button will convert any number from time to decimal, and vise-versa.

        \(header2)
            There are virtually tens-of-thousands of functions that provide direct unit conversion from categories such as currencies, length/distance, temperature, volume etc. You select a function by tapping the "Functions" button as the top of the calculator. A new screen will then show all of the available functions.
            
            Selecting to two units from the same conversion category, will put the calculator into the function mode. If a number has already been entered into the calculator, the conversion will automatically be performed on that number and the result will be displayed. However, if no number has been entered at the time the conversion was selected, the calculator will ask you to input the number that you are converting from. Once that number has been entered, it will then display the converted amount.
        
        \(header3)
            Additionally, there are numerous pre-programmed formulas available that also accessed by tapping the "Functions" button at the top of the calculator.
        
            Selecting any of the formulas will put the calculator in the function mode.  The calculator will prompt the user to enter the needed variables to provide the result.  For example, if the Monthly Payment Calculation is selected from the Finacial Category, the user will be asked to enter: "Amount to be borrowed?", "Length of Loan (Months)?", "Interest Rate APR (i.e. 0.065)?". After the last input is made, the resultant answer will then be displayed as "Payment X.XX/mo". The result may also be uses in further calculations by pressing "USE" button or any of the math operator keys.
        
        \(aviationDisclaimerText)
        
        \(header4)
        The currency conversions are especially versatile as the more than 150 preloaded currencies' exchange rates are updated every hour, so the app always has the most up-to-date exchange rates available while it has Internet connectivity.  If the app does not have access to the Internet, it will continue to perform currency conversions, however, it will use the last downloaded rates.  If the calculator is using older rates, an information box will let the user know the date of the last downloaded rates at the time of the conversion.
        
        The latest rates download status can also be viewed in the “More Stuff” section. Pulling down on the section will attempt to refresh the data as well.
        
        Specific countries may be "favorited" so only the countries of interest will be viewed when selecting conversions or viewing their current exchange rates. The displayed countries may be toggled between favorited and all by tapping the \(favoriteStar) button.
        
        The base currency, which is what the downloaded rates are valued, may be changed to any of the downloaded currencies.  This does not affect the conversions, just the values when viewing the exchange rates in the “More Stuff” section.
        
        \(header5)
        Lastly, to make it easier and quicker to access the built-in functions listed above, FunctionCalc has preset buttons that allow for storage of often used formulas and conversions for a one-tap operation. Assigning a function to the pre-set buttons is accomplished when selecting the function and tapping the "store to preset" button.  You may also update the presets by pressing and holding any of the function preset buttons.
        """
        
        // Creates the text string of what to be displayed in the textView
        let textString              = bodyText
        
        // Converts the textString to a NSMutableAttributedString
        let attrText                = NSMutableAttributedString(string: textString)
        
        // Set the font constants for the different elements
        let subTitleFont            = Fonts.instructSubTitle
        let bodyFont                = Fonts.instructBody
        let headerFont              = Fonts.instructHeader
        
        // Creates a center justified paragraph style constant
        let subTitleParagraph       = NSMutableParagraphStyle()
        subTitleParagraph.alignment = .center
        
        let bullet                  = NSMutableParagraphStyle()
        bullet.alignment            = .left
        bullet.headIndent           = 15.0
        
        //  Converst the text elements to ranges
        let subTitleRange           = (textString as NSString).range(of: subTitleText)
        let header0Range            = (textString as NSString).range(of: header0)
        let bulletPointsRange       = (textString as NSString).range(of: bulletPoints)
        let header1Range            = (textString as NSString).range(of: header1)
        let header2Range            = (textString as NSString).range(of: header2)
        let header3Range            = (textString as NSString).range(of: header3)
        let header4Range            = (textString as NSString).range(of: header4)
        let header5Range            = (textString as NSString).range(of: header5)
        let hyperLinkRange          = (textString as NSString).range(of: hyperLinkText)
        let mailToRange             = (textString as NSString).range(of: mailToLinkText)
        let favoriteStarRange       = (textString as NSString).range(of: favoriteStar)
       
        
        // Calculates the length of the body by subtracting the overlength - start
        let bodyLength              = textString.count
        let bodyRange               = NSRange.init(location: 0, length: bodyLength)
        
        // Body
        attrText.addAttribute(.font, value: bodyFont, range: bodyRange)
        
        // Hyperlinks
        attrText.addAttribute(.link, value: "https://www.lawlerinnovationsinc.com/functioncalc", range: hyperLinkRange)
        attrText.addAttribute(.link, value: "mailto:pat@lawlerinnovationsinc.com", range: mailToRange)
        
       
        // Title
        attrText.addAttribute(.font, value: subTitleFont, range: subTitleRange)
        attrText.addAttribute(.paragraphStyle, value: subTitleParagraph, range: subTitleRange)
        attrText.addAttribute(.paragraphStyle, value: bullet, range: bulletPointsRange)
        
        // Headers
        attrText.addAttribute(.font, value: headerFont, range: header0Range)
        attrText.addAttribute(.font, value: headerFont, range: header1Range)
        attrText.addAttribute(.font, value: headerFont, range: header2Range)
        attrText.addAttribute(.font, value: headerFont, range: header3Range)
        attrText.addAttribute(.font, value: headerFont, range: header4Range)
        attrText.addAttribute(.font, value: headerFont, range: header5Range)
        
        // Add Images
        attrText.replaceCharacters(in: favoriteStarRange, with: filledStar)

        return attrText
    }
}
