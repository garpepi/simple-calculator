//
//  ViewController.swift
//  simple calculator
//
//  Created by Garpepi Aotearoa on 08/04/23.
//

import UIKit

enum currencies {
    case idr
    case usd
}


class ViewController: UIViewController {

    @IBOutlet weak var calculateLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!

    let currencies: currencies = .idr

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calculateLabel.text = ""
        resultLabel.text = ""
    }

    @IBAction func number(_ sender: Any) {
        guard let tag = (sender as? UIButton)?.tag else {return}
        if tag >= 0 && tag < 9 {
            assignNumber(String(tag))
        }
    }

    @IBAction func mathOperator(_ sender: Any) {
        guard let tag = (sender as? UIButton)?.tag else {return}

        switch tag {
        case 11:
            assignMathOperator("+")
        case 12:
            assignMathOperator("-")
        case 13:
            assignMathOperator("/")
        case 14:
            assignMathOperator("x")
        default:
            return
        }
    }

    @IBAction func deleteActionField(_ sender: Any) {
        var tmpTxt = ""
        if let txt = calculateLabel.text {
            if txt.suffix(1) == " " {
                tmpTxt = String(txt.dropLast(3))
            } else {
                tmpTxt = String(txt.dropLast())
                if tmpTxt.suffix(1) == " " {
                    tmpTxt = String(tmpTxt.dropLast(3))
                }
            }

            if tmpTxt == "" {
                calculateLabel.text = ""
                resultLabel.text = ""
            } else {
                if let result = calc(tmpTxt.components(separatedBy: " ")) {
                    resultLabel.text = String(result)
                    calculateLabel.text = tmpTxt
                } else {
                    resultLabel.text = String(tmpTxt)
                    calculateLabel.text = tmpTxt
                }
            }
        }
    }

    private func assignNumber(_ number: String) {
        // if current no number, cannot press 0
        if let txt = calculateLabel.text,
           txt.suffix(1) == "" || txt.suffix(1) == " " || txt.suffix(2) == "/ " || txt.suffix(2) == "x ",
           number == "0" {
            // stop
            print("CANNOT 0 IN FRONT")
            return
        }


        let tmpTxt = (calculateLabel.text ?? "") + number
        let countOpr = countOperator(tmpTxt)
        if countOpr > 0 {
            let arrayTxt = tmpTxt.components(separatedBy: " ")
            if let result = calc(arrayTxt),
               validateCalc(result) {
                calculateLabel.text = tmpTxt
                resultLabel.text = "= " + String(result)
            } else {
                // show error or stop
                print("NOT ELIGIBLE")
            }
        } else {
            calculateLabel.text = (calculateLabel.text ?? "") + number
        }

    }

    private func assignMathOperator(_ mathOpr: String) {
        guard let txt = calculateLabel.text else {return}

        let operatorToAdd = " " + mathOpr + " "

        let tmpTxt = txt + operatorToAdd
        let arrayTmpTxt = tmpTxt.components(separatedBy: " ")

        if validateOperator(arrayTmpTxt, 0) == nil {
            return
        }


        let countOpr = countOperator(tmpTxt)
        if countOpr > 1 {
            if nil != validateOperator(arrayTmpTxt, 2) {
                // calc
                if let result = calc(arrayTmpTxt),
                   validateCalc(result) {
                    calculateLabel.text = String(result) + operatorToAdd
                    resultLabel.text = "= " + String(result)
                }
            } else {
                if let firstNumber = validateOperator(arrayTmpTxt, 0) {
                    calculateLabel.text = String(firstNumber) + operatorToAdd
                    resultLabel.text = "= " + String(firstNumber)
                }
            }
        } else {
            calculateLabel.text = txt + operatorToAdd
        }
    }

    private func validateCalc(_ result: Double) -> Bool {
        if result.isLess(than: 0.0) {
            print(" CANNOT LESS THAN ZERO")
            return false
        } else if String(result).count - 1 > 12 {
            print(" CANNOT MORE THAN 15 CHARACTER")
            return false
        } else {
            return true
        }
    }

    private func validateOperator(_ arrayTxt: [String], _ index: Int) -> Double? {
        return Double(arrayTxt[index])
    }

    private func countOperator(_ tmpTxt: String) -> Int {
        return tmpTxt.components(separatedBy: " ").filter({ $0 == "x" || $0 == "+" || $0 == "/" || $0 == "-"}).count
    }

    private func calc(_ arrayOfText: [String]) -> Double? {
        if !arrayOfText.indices.contains(2) {
            return nil
        }

        if arrayOfText[2].isEmpty {
            return nil
        }

        let firstNumber = Double(arrayOfText[0]) ?? 0.0
        let secondNumber = Double(arrayOfText[2]) ?? 0.0

        switch arrayOfText[1] {
        case "x":
            return firstNumber * secondNumber
        case "/":
            return firstNumber / secondNumber
        case "+":
            return firstNumber + secondNumber
        case "-":
            return firstNumber - secondNumber
        default:
            return nil
        }
    }

}
