//
//  Common.swift
//  CalculatorTutorial
//
//  Created by Garpepi Aotearoa on 09/04/23.
//

import UIKit


extension String {
    /// Convert nominal string to use currency format
    /// - Returns: return a string with currency format without IDR and decimal digits, e.g. `100,000`
    func convertToCurrency() -> String {
        guard let doubleValue = Double(self) else { return self }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        formatter.currencyGroupingSeparator = ","
        formatter.currencySymbol = ""
        formatter.roundingMode = .down
        return formatter.string(from: NSNumber(value: doubleValue)) ?? self
    }

    /// Convert nominal string to use currency format with decimal
    /// - Returns: return a string with currency format with IDR and decimal digits, e.g. `IDR 10,000.00`
    func convertToCurrencyWithDecimal() -> String {
        guard let doubleValue = Double(self) else { return self }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_EN")
        formatter.currencyGroupingSeparator = ","
        formatter.currencyDecimalSeparator = "."
        formatter.currencySymbol = ""
        return formatter.string(from: NSNumber(value: doubleValue)) ?? self
    }
}


