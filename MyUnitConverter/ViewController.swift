//
//  ViewController.swift
//  MyUnitConverter
//
//  Created by Max Kravchenko on 1/10/15.
//  Copyright (c) 2015 Max Kravchenko. All rights reserved.
//

import UIKit

enum UnitType: Int {
    case Meter, Mile, Yard, Foot, Inch, Hand
    static let allTypeNames = ["Meter", "Mile", "Yard", "Foot", "Inch", "Hand"]
    static let allVals = [1, 0.000621, 1.093613, 3.28084, 39.370079, 9.84252]
}

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var output: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    
    var fromUnitType, toUnitType : UnitType?
    var unitTypes: [String]?
    var inputNumber : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        input.addTarget(self, action: "setOutput", forControlEvents: UIControlEvents.AllEditingEvents)
        input.delegate = self
        output.enabled = false
        picker.dataSource = self
        picker.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: UIPickerDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 || component == 2 {
            return UnitType.allTypeNames.count
        } else {
            return 1
        }
    }
    
    //MARK: UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if component == 0 || component == 2 {
            return UnitType.allTypeNames[row]
        } else {
            return "to"
        }
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            fromUnitType = UnitType(rawValue: row)
            self.setOutput()
        } else if component == 2 {
            toUnitType = UnitType(rawValue: row)
            self.setOutput()
        } else {}
    }

    //MARK: UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = countElements(textField.text!) + countElements(string) - range.length
        return newLength <= 7
    }
    
    //MARK: calculations
    func setOutput() {
        inputNumber = (input.text as NSString).doubleValue
        if inputNumber == 0 {
            output.text = nil
        } else {
            let inputIndex = toUnitType?.rawValue ?? 0
            let changeIndex = fromUnitType?.rawValue ?? 0
            let inputValue = UnitType.allVals[inputIndex]
            let changeValue = UnitType.allVals[changeIndex]
            let result = inputNumber! * inputValue / changeValue
            if result % round(result) == 0 {
                output.text = String("\(Int(result))")
            } else {
                output.text = String(format:"%f", result)
            }
        }
    }
}

