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
    
    @IBOutlet weak var dayLabel: UILabel!
    //Array containing the 7 exercise views by day
    var viewsByDay : [ExercisesByDayView] = []
    var currDay : Int = 1
    var currView: UIViewController! = nil
    @IBOutlet weak var scrollView: UIScrollView!
    //@IBOutlet weak var scrollView: UIScrollView!
    //Defining outlet for scrollview handling horizontal swipes
    //@IBOutlet weak var swipeScrollView: UIScrollView!

    //Apparently this is how you're supposed to override initializers for UIViewControllers in Swift??
    //I am populating the exercise view array in the init() since we only want to call it once in this object's lifecycle
    convenience init()
    {
        self.init()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let calendar = NSCalendar.current
        let date = NSDate()
        currDay = calendar.component(.weekday, from: date as Date)
        //Populate array
        for i in 1...7 {
            let newView : ExercisesByDayView = ExercisesByDayView(day : DaysInAWeek(rawValue: i)!)               //ExercisesByDayView(nibName: "ExercisesByDayView", bundle: nil)
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
        
        addDayViewToScrollView(dayToDisplay: DaysInAWeek(rawValue: currDay)!)
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    //Takes in the integer index of the desired day to display on page
    func addDayViewToScrollView(dayToDisplay : DaysInAWeek)
    {
        let newView = viewsByDay[dayToDisplay.rawValue - 1]
        
        scrollView.addSubview(newView.view)
        newView.didMove(toParentViewController: self)
        
        var newFrame : CGRect = newView.view.frame
        newFrame.origin.x = newView.view.frame.origin.x
        newView.view.frame = newFrame
        
        scrollView.contentSize = CGSize(width: newView.view.frame.width, height: newView.view.frame.height)
        dayLabel.text = DaysInAWeek(rawValue: currDay)!.name
        currView = newView

    }
    
    //Overloaded function for adding day view to scrollview buth with animation when swipe is detected
    func addDayViewToScrollView(dayToDisplay : DaysInAWeek, direction : UIRectEdge)
    {
        scrollView.contentSize = CGSize(width: currView.view.frame.width + currView.view.frame.width, height: currView.view.frame.height)
        
        let newView = viewsByDay[dayToDisplay.rawValue - 1]
        scrollView.addSubview(newView.view)
        if (direction == .right)
        {            
            var newFrame : CGRect = newView.view.frame
            newFrame.origin.x = currView.view.frame.origin.x + currView.view.frame.width
            newView.view.frame = newFrame
            
            //scrollView.frame.origin.x += scrollView.frame.origin.x
            UIView.animate(withDuration: 0.5, animations: {
                self.currView.view.center.x -= self.currView.view.frame.width
            })
            UIView.animate(withDuration: 0.5, animations: {
                newView.view.center.x -= newView.view.frame.width
            })
            currView.view.removeFromSuperview()
            currView = newView
            scrollView.contentSize = CGSize(width: currView.view.frame.width, height: currView.view.frame.height)

        }
        else
        {
            var newFrame : CGRect = newView.view.frame
            newFrame.origin.x = currView.view.frame.origin.x - currView.view.frame.width
            newView.view.frame = newFrame
            
            //scrollView.frame.origin.x += scrollView.frame.origin.x
            UIView.animate(withDuration: 0.5, animations: {
                self.currView.view.center.x += self.currView.view.frame.width
            })
            UIView.animate(withDuration: 0.5, animations: {
                newView.view.center.x += newView.view.frame.width
            })
            currView.view.removeFromSuperview()
            currView = newView
            scrollView.contentSize = CGSize(width: currView.view.frame.width, height: currView.view.frame.height)
        }
    }
    
    func handleSwipes(_ recognizer: UIScreenEdgePanGestureRecognizer){
        
        if (recognizer.state == .recognized) {
            if(recognizer.edges == .left)
            {
                //Remove preexisting view
                /*for view in scrollView.subviews
                {
                    view.removeFromSuperview()
                }*/
                
                //If the page is at Sunday, swiping left should get you to Saturday
                if (currDay == DaysInAWeek.Sunday.rawValue)
                {
                    currDay = DaysInAWeek.Saturday.rawValue
                    addDayViewToScrollView(dayToDisplay: DaysInAWeek.Saturday, direction : .left)
                    
                }
                else
                {
                    currDay -= 1
                    addDayViewToScrollView(dayToDisplay: DaysInAWeek(rawValue: currDay)!, direction : .left)
                }
            }
            if(recognizer.edges == .right) {
                //Remove preexisting view
                /*for view in scrollView.subviews
                {
                    view.removeFromSuperview()
                }*/
                
                //If the page is at Saturday, swiping right should get you to Sunday
                if (currDay == DaysInAWeek.Saturday.rawValue)
                {
                    currDay = DaysInAWeek.Sunday.rawValue
                    addDayViewToScrollView(dayToDisplay: DaysInAWeek.Sunday, direction : .right)
                }
                else
                {
                    currDay += 1
                    addDayViewToScrollView(dayToDisplay: DaysInAWeek(rawValue: currDay)!, direction : .right)
                }
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

