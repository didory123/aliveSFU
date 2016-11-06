//
//  MyProgressController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-10-26.
//  Developers: Liam O'Shaughnessy
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit
import CoreData

class MyProgressController: UIViewController {
    
    //Array containing the 7 exercise views by day
    var viewsByDay : [ExercisesByDayView] = []
    
    @IBOutlet weak var scrollView: UIScrollView!
    //@IBOutlet weak var scrollView: UIScrollView!
    //Defining outlet for scrollview handling horizontal swipes
    //@IBOutlet weak var swipeScrollView: UIScrollView!

    //Apparently this is how you're supposed to override initializers for UIViewControllers in Swift??
    //I am populating the exercise view array in the init() since we only want to call it once in this object's lifecycle
    convenience init()
    {
        self.init(nibName:nil, bundle:nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let calendar = NSCalendar.current
        let date = NSDate()
        let currDay = calendar.component(.weekday, from: date as Date)
        
        //Populate array
        for i in 0...6 {
            let newView : ExercisesByDayView = ExercisesByDayView(day : currDay)               //ExercisesByDayView(nibName: "ExercisesByDayView", bundle: nil)
            self.addChildViewController(newView)
            viewsByDay.append(newView)
            /*self.containerView.addSubview(newView.view) //adding this newly created view to the scroll view that is used to implement swiping
            newView.didMove(toParentViewController: self)
            
            if (i != 0)
            {
                //Line up the views in ascending day order so the user can swipe through them
                var newFrame : CGRect = viewsByDay[i-1].view.frame
                newFrame.origin.x = viewsByDay[i-1].view.frame.origin.x + viewsByDay[i].view.frame.width
                newView.view.frame = newFrame
            }*/
        }
            //swipeScrollView.contentSize = CGSize(width: viewsByDay[0].view.frame.width * 7, height: self.swipeScrollView.frame.height)
        //containerView.addSubview(viewsByDay[day].view)
        let leftEdge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector (handleSwipes(_:)))
        let rightEdge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector (handleSwipes(_:)))
        
        leftEdge.edges = .left
        rightEdge.edges = .right
        
        view.addGestureRecognizer(leftEdge)
        view.addGestureRecognizer(rightEdge)
        
        let currView = viewsByDay[currDay-1]
        self.scrollView.addSubview(currView.view)
        currView.didMove(toParentViewController: self)
        
        var newFrame : CGRect = currView.view.frame
        newFrame.origin.x = currView.view.frame.origin.x
        currView.view.frame = newFrame

        scrollView.contentSize = CGSize(width: currView.view.frame.width, height: currView.view.frame.height)

        // Do any additional setup after loading the view, typically from a nib.

    }


    
    func handleSwipes(_ recognizer: UIScreenEdgePanGestureRecognizer){
        
        if (recognizer.state == .recognized) {
            if(recognizer.edges == .left) {
                print("Swipe Right from left edge ")//dummy code
                }
            if(recognizer.edges == .right) {
                print("Swipe Left from right edge") //dummy code
                }
        }
        //NEED TO GET ARRAY DATA AND CHANGE TILES IN THE VIEW CONTROLLER
    }
    /*
    func populateStackView() {
        let exerciseArrayCount = DataHandler.getExerciseArrayCount()
        if (exerciseArrayCount == 0) {
            //Display Placeholder Exercise Tile
            print("Works")
        } else {
            //Populate Exercise Tiles
            let exerciseArray = DataHandler.getExerciseArray()

            for elem in exerciseArray {
                if (elem.category == elem.CATEGORY_CARDIO) {
                    let tile = CardioTileView(name: elem.exerciseName, time: elem.time, speed: elem.speed, resistance: elem.resistance)
                    stackView.addArrangedSubview(tile)
                } else {
                    let tile = StrengthTileView(name: elem.exerciseName, sets: elem.sets, reps: elem.reps)
                    stackView.addArrangedSubview(tile)
                }
            }
        }
    }*/

}

