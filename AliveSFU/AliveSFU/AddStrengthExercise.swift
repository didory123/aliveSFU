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
    var exerciseDayStrength: Int = 0   //variable that will store the result from what is chosen on the segmented display
    //Vivek: Whenever the segmented display is touched, the int corresponding to the day will
    //be stored in the variable "exerciseDay"

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
            //remember to increment exerciseDayCardio by 1 because the NSDate indexing for weekdays start at 1
            let newExercise = ExerciseFactory.returnExerciseByCategory(type: ExerciseType.Strength, exerciseName: exerciseNameInput.text!, day: DaysInAWeek(rawValue : exerciseDayStrength+1)!, completed: false)

            (newExercise as! StrengthExercise).sets = setsInput.text!
            (newExercise as! StrengthExercise).reps = repsInput.text!
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

