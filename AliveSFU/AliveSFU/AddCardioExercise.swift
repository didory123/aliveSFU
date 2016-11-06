//
//  AddCardioExercise.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-10-26.
//  Developers: Gur Kohli, Gagan Kaur, Vivek Sharma
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class AddCardioExercise: UIViewController {
    
    //Mark: Properties

    @IBOutlet weak var exerciseNameInput: UITextField!
    @IBOutlet weak var speedInput: UITextField!
    @IBOutlet weak var timeInput: UITextField!
    @IBOutlet weak var resistanceInput: UITextField!
    //Vivek:
    var exerciseDayCardio: Int = 1
    //Vivek:
    

    @IBAction func theDayCardio(_ sender: UISegmentedControl) {
        exerciseDayCardio = sender.selectedSegmentIndex
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
        if ((exerciseNameInput.text != "") && (timeInput.text != "") && (speedInput.text != "") && (resistanceInput.text != "") )
        {
            let newExercise = ExerciseFactory.returnExerciseByCategory(type: .Cardio, exerciseName: exerciseNameInput.text!, day: DaysInAWeek(rawValue : exerciseDayCardio)!, completed: false)
            (newExercise as! CardioExercise).speed = speedInput.text!
            (newExercise as! CardioExercise).resistance = resistanceInput.text!
            (newExercise as! CardioExercise).time = timeInput.text!
            let result = DataHandler.saveElementToExerciseArray(elem: newExercise)
            if (result == -1) {
                //Handle Error
            }
            
            DataHandler.getExerciseArray()
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            //Do something
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

