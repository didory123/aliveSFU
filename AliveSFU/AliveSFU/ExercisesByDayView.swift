//
//  ExercisesByDayView.swift
//  AliveSFU
//
//  Created by Jim Park on 2016-11-05.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit
import CoreData

class ExercisesByDayView: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    var day : Int = 0
    convenience init( day : Int ) {
        self.init()
        self.day = day
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        for view in stackView.subviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateStackView() {
        let exerciseArrayCount = DataHandler.getExerciseArrayCount()
        if (exerciseArrayCount == 0) {
            //Display Placeholder Exercise Tile
            print("Works")
        } else {
            //Populate Exercise Tiles
            let exerciseArray = DataHandler.getExerciseArray()
            
            for elem in exerciseArray {
                if (elem.day.rawValue == day)
                {
                    if (elem.category == elem.CATEGORY_CARDIO) {
                        let tile = CardioTileView(name: elem.exerciseName, time: elem.time, speed: elem.speed, resistance: elem.resistance)
                        stackView.addArrangedSubview(tile)
                    } else {
                        let tile = StrengthTileView(name: elem.exerciseName, sets: elem.sets, reps: elem.reps)
                        stackView.addArrangedSubview(tile)
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateStackView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        for view in stackView.subviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize.height = stackView.frame.height + 200
        //scrollView.isScrollEnabled = true;
        //scrollView.isUserInteractionEnabled = true;
    }
    
    @IBAction func showPopup(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tilePopUpID") as! ExerciseTileViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
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
