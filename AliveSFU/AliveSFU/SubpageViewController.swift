//
//  SubpageViewController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-14.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class SubpageViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validateFields() -> Bool {
        // Check if the fields are filled before moving to next page
        // Throw alerts if a field isn't filled
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getSubpages() -> [SubpageViewController] {
        // Initialized arr with an empty view controller to make it 1-indexed
        var arr = [SubpageViewController()]
        
        let subpage1 = UIStoryboard(name: "firstTime", bundle: nil).instantiateViewController(withIdentifier: "1") as! Subpage1ViewController
        let subpage2 = UIStoryboard(name: "firstTime", bundle: nil).instantiateViewController(withIdentifier: "2") as! Subpage2ViewController
        let subpage3 = UIStoryboard(name: "firstTime", bundle: nil).instantiateViewController(withIdentifier: "3") as! Subpage3ViewController
        let subpage4 = UIStoryboard(name: "firstTime", bundle: nil).instantiateViewController(withIdentifier: "4") as! Subpage4ViewController
        
        arr.append(subpage1)
        arr.append(subpage2)
        arr.append(subpage3)
        arr.append(subpage4)
        
        return arr
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

/*
    Subpage 1 - My Profile
 */

class Subpage1ViewController: SubpageViewController {
    
    @IBOutlet weak var userFirstName: UITextField!
    @IBOutlet weak var userLastName: UITextField!
    @IBOutlet weak var userGender: UISegmentedControl!
    @IBOutlet weak var userPhoneNumber: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var emptyAlertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userPhoneNumber.keyboardType = .phonePad
        userEmail.keyboardType = .emailAddress
    }
    
    override func validateFields() -> Bool {
        //smyTextField.layer.borderColor = UIColor( red: CGFloat, green: CGFloat, blue:CGFLoat, alpha: CGFloat ).CGColor
        // Check if the fields are filled before moving to next page
        // Throw alerts if a field isn't filled
        return true
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        if (validateFields()) {
            performSegue(withIdentifier: "showSubpage2", sender: self)
        } else {
            // Show errors if field not validated
        }
    }
}

class Subpage2ViewController: SubpageViewController {
    

    @IBOutlet var fitnessFrequency: [UIButton]!
    @IBOutlet var personalGoals: [UIButton]!
    @IBOutlet var ageGroup: [UIButton]!
    @IBOutlet var height: [UITextField]!
    @IBOutlet var weight: [UITextField]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for btn in height {
            btn.keyboardType = .decimalPad
        }
        for btn in weight {
            btn.keyboardType = .decimalPad
        }
    }
    
    override func validateFields() -> Bool {
        // Check if the fields are filled before moving to next page
        // Throw alerts if a field isn't filled
        return true
    }
    
    @IBAction func selectFitnessFrequency(_ sender: UIButton) {
        //Dismiss all the keyboards
        self.view.endEditing(true)
        
        for button in fitnessFrequency {
            if (button == sender) {
                button.isSelected = true
                
                // User has selected this particular fitness frequency.
                // Add/Update this value in the temp variable that will be later saved to local storage

            } else {
                button.isSelected = false
            }
        }
    }
    
    @IBAction func selectAgeGroup(_ sender: UIButton) {
        //Dismiss all the keyboards
        self.view.endEditing(true)
        
        for button in ageGroup {
            if (button == sender) {
                button.isSelected = true
                
                // User has selected this particular age group.
                // Add/Update this value in the temp variable that will be later saved to local storage
                
            } else {
                button.isSelected = false
            }
        }
    }

    @IBAction func selectPersonalGoals(_ sender: UIButton) {
        //Dismiss all the keyboards
        self.view.endEditing(true)

        sender.isSelected = !sender.isSelected
        
        for button in personalGoals {
            if (button.isSelected) {
                // This value is selected as a personal goal.
                // Change values in the temp variable that will be later saved to local storage
            }
        }
    }
    
    @IBAction func updateWeight(_ sender: UITextField) {
        if (sender == weight[0]) { // If kg field was updated
            
            // Calculate the lb field
            if (weight[0].text != "") {
                let kg = Double(weight[0].text!)!
                let lb = kg * 2.2046
                weight[1].text = String(format: "%.1f", lb)
            }
            
        } else if (sender == weight[1]) { // If lb field was updated
            
            //Calculate the kg field
            if (weight[1].text != "") {
                let lb = Double(weight[1].text!)!
                let kg = lb / 2.2046
                weight[0].text = String(format: "%.1f", kg)
            }
        }
    }
    
    @IBAction func updateHeight(_ sender: UITextField) {
        if (sender == height[0]) { // If ft field was updated
            if (height[0].text != "") {
                // Add/Update this value in the temp variable that will be later saved to local storage
            }
            
        } else if (sender == height[1]) { // If inches field was updated
            if (height[1].text != "") {
                // Add/Update this value in the temp variable that will be later saved to local storage
            }
        }
    }

    @IBAction func nextBtnAction(_ sender: UIButton) {
        if (validateFields()) {
            performSegue(withIdentifier: "showSubpage3", sender: self)
        } else {
            // Show errors if field not validated
        }
    }
    
}

class Subpage3ViewController: SubpageViewController {
    
    @IBOutlet var enableDisableSleepAnalysis: [UIButton]!
    
    let ENABLE_BUTTON_TAG = 100;
    let DISABLE_BUTTON_TAG = 200;
    
    override func validateFields() -> Bool {
        // Check if the fields are filled before moving to next page
        // Throw alerts if a field isn't filled
        return true
    }
    
    @IBAction func toggleEnableDisableSleep(_ sender: UIButton) {
        
        for button in enableDisableSleepAnalysis {
            if (sender == button) {
                button.isSelected = true
                if (button.tag == ENABLE_BUTTON_TAG) {
                    // Enable sleep analysis in the temp variable
                    
                } else if (button.tag == DISABLE_BUTTON_TAG) {
                    // Disable sleep analysis in the temp variable
                }
            } else {
                button.isSelected = false
            }
        }
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        if (validateFields()) {
            performSegue(withIdentifier: "showSubpage4", sender: self)
        } else {
            // Show errors if field not validated
        }
    }
    
}

class Subpage4ViewController: SubpageViewController {
    
    @IBOutlet var enableDisableButton: [UIButton]!
    
    let ENABLE_BUTTON_TAG = 100;
    let DISABLE_BUTTON_TAG = 200;
    
    override func validateFields() -> Bool {
        // Check if the fields are filled before moving to next page
        // Throw alerts if a field isn't filled
        return true
    }
    
    @IBAction func toggleEnableDisable(_ sender: UIButton) {

        for button in enableDisableButton {
            if (sender == button) {
                button.isSelected = true
                if (button.tag == ENABLE_BUTTON_TAG) {
                    // Enable fitness buddy in the temp variable
                    
                } else if (button.tag == DISABLE_BUTTON_TAG) {
                    // Disable fitness buddy in the temp variable
                }
            } else {
                button.isSelected = false
            }
        }
    }
    
    @IBAction func finishBtnAction(_ sender: Any) {
        if (validateFields()) {
            // Save all data and go to home page
        } else {
            // Show errors if field not validated
        }
    }
    
    
}
