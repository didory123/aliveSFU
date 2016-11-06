//
//  PopoverCardioTile.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-05.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class PopoverCardioTile: UIViewController {
    
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var resistance: UILabel!
    
    @IBOutlet weak var exerciseNameTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var speedTextField: UITextField!
    @IBOutlet weak var resistanceTextField: UITextField!
    
    @IBOutlet weak var editableButtons: UIStackView!
    @IBOutlet weak var changeExerButton: UIButton!
    
    @IBOutlet weak var staticRows: UIStackView!
    @IBOutlet weak var editableRows: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        showEditable(yes: false)
        self.showAnimate()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func changeExercise(_ sender: AnyObject) {
            exerciseNameTextField.text = exerciseName.text
        timeTextField.text = time.text
        speedTextField.text = speed.text
        resistanceTextField.text = resistance.text
        showEditable(yes: true)
    }

    @IBAction func closePopUp(_ sender: Any) {
        self.removeAnimate()
    }
    
    @IBAction func deleteButton(_ sender: AnyObject) {
    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        showEditable(yes: false)
    }
    
    @IBAction func saveButton(_ sender: AnyObject) {
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool) in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    func showEditable(yes: Bool) {
        exerciseName.isHidden = yes
        staticRows.isHidden = yes
        changeExerButton.isHidden = yes
        
        editableRows.isHidden = !yes;
        exerciseNameTextField.isHidden = !yes;
        editableButtons.isHidden = !yes;
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
