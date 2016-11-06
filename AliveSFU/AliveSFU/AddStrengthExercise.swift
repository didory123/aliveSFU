//
//  AddStrengthExercise.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-10-26.
//  Developers: Gur Kohli, Gagan Kaur, Vivek Sharma
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class AddStrengthExercise: UIViewController {
    
    //Mark: Properties

    @IBOutlet weak var exerciseNameInput: UITextField!
   
    @IBOutlet weak var setsInput: UITextField!
    @IBOutlet weak var repsInput: UITextField!
    //Vivek:
    var exerciseDayStrength: Int = 0    //variable that will store the result from what is chosen on the segmented display
    //Vivek: Whenever the segmented display is touched, the int corresponding to the day will
    //be stored in the variable "exerciseDayStrength"

    @IBAction func theDayStrength(_ sender: UISegmentedControl) {
        exerciseDayStrength = sender.selectedSegmentIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: Action
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        // Check for valid values like max number of characters that can be entered etc.
        // Create a new object
        if (exerciseNameInput.text != "" && setsInput.text != "" && repsInput.text != "") {
            let newExercise = Exercise()
            newExercise.category = newExercise.CATEGORY_STRENGTH
            newExercise.exerciseName = exerciseNameInput.text!
            newExercise.sets = setsInput.text!
            newExercise.reps = repsInput.text!
            let day = DaysInAWeek(rawValue: exerciseDayStrength + 1)
            newExercise.setDay(day: day!)
            let result = DataHandler.saveElementToExerciseArray(elem: newExercise)
            if (result == -1) {
                //Handle Error
            }
            DataHandler.getExerciseArray()
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            
        }
    }

    @IBAction func cancelButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
   

}

