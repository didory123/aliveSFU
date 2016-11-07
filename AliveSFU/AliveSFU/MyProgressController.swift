//
//  MyProgressController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-10-26.
//  Developers: Liam O'Shaughnessy, Vivek Sharma
//  Copyright © 2016 SimonDevs. All rights reserved.
//  Partial functionality adapted from a third party resource: https://github.com/thefirstnikhil/chartingdemo
//

import UIKit
import CoreData
import JBChart

//An extension to UIColor to allow the creation of our own colours using RGB numbers
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
    //3rd party libraries added here
class MyProgressController: UIViewController, JBBarChartViewDelegate, JBBarChartViewDataSource {
    
    @IBOutlet weak var daySelected: UISegmentedControl!
    @IBOutlet weak var barChart: JBBarChartView! //The view the bar chart rests in
    @IBOutlet weak var informationLabel: UILabel! //The label that display info when a bar is tapped
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    var currDay : DaysInAWeek = DaysInAWeek.Sunday
    let CATEGORY_CARDIO_VIEW_TAG = 100
    let CATEGORY_STRENGTH_VIEW_TAG = 200
    let TILE_HEIGHT = CGFloat(80)
    
    var chartLegend = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"] //x-axis information
    //let chartData = [5, 8, 6, 2, 9, 6, 4]//sample data to display bar graph, replace with actual exercise completion numbers
    let chartData = DataHandler.countCompletion() //Array that counts completed exercises
    let SFURed = UIColor(red: 166, green: 25, blue: 46)
    let SFUGrey = UIColor(red: 84, green: 88, blue: 90)
    override func viewDidLoad() {
        super.viewDidLoad()
        let calendar = NSCalendar.current
        let date = NSDate()
        currDay = DaysInAWeek(rawValue : calendar.component(.weekday, from: date as Date))!
        setupBarChart()
        
        //get today's date
        
        let leftEdge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector (handleSwipes(_:)))
        
        let rightEdge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector (handleSwipes(_:)))
        
        leftEdge.edges = .left
        rightEdge.edges = .right
        
        view.addGestureRecognizer(leftEdge)
        view.addGestureRecognizer(rightEdge)
        // Do any additional setup after loading the view, typically from a nib.
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        barChart.reloadData()
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(MyProgressController.showChart), userInfo: nil, repeats: false)
    }
    @IBAction func dayValueChangeEvent(_ sender: UISegmentedControl) {
        for view in contentView.subviews
        {
            view.removeFromSuperview()
        }
        var changedIndex = sender.selectedSegmentIndex
        currDay = DaysInAWeek(rawValue: changedIndex + 1)!
        populateStackView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateStackView()
        contentViewHeight.constant = CGFloat(contentView.subviews.count) * TILE_HEIGHT
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
    }
    
    //Uncomment this if you wish for the labels to go away once a bar on the graph is unselected
    /*func didDeselect(_ barChartView: JBBarChartView!) {
        informationLabel.text = ""
    }*/
    
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize.height = CGFloat(contentView.subviews.count) * TILE_HEIGHT
        scrollView.isScrollEnabled = true;
        scrollView.isUserInteractionEnabled = true;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func showPopup(_ sender: UITapGestureRecognizer) {

        if (sender.view?.tag == CATEGORY_CARDIO_VIEW_TAG) {
            let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardioTilePopover") as! PopoverCardioTile
            self.addChildViewController(popoverVC)
            popoverVC.view.frame = self.view.frame
            popoverVC.view.tag = 600
            self.view.addSubview(popoverVC.view)
            
            let tile = sender.view as! CardioTileView
            popoverVC.exerciseName.text = tile.exerciseName.text
            popoverVC.time.text = tile.time.text
            popoverVC.speed.text = tile.speed.text
            popoverVC.resistance.text = tile.resistance.text
            popoverVC.didMove(toParentViewController: self)

        } else if (sender.view?.tag == CATEGORY_STRENGTH_VIEW_TAG) {
            let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "strengthTilePopover") as! PopoverStrengthTile
            self.addChildViewController(popoverVC)
            popoverVC.view.frame = self.view.frame
            self.view.addSubview(popoverVC.view)
            
            let tile = sender.view as! StrengthTileView
            popoverVC.exerciseName.text = tile.exerciseName.text
            popoverVC.sets.text = tile.sets.text
            popoverVC.reps.text = tile.reps.text
            popoverVC.didMove(toParentViewController: self)
        }
    }
    
    //Event handler for detecting when the user swipes the page left or right
    //Post condition: should change the currently displayed page
    func handleSwipes(_ recognizer: UIScreenEdgePanGestureRecognizer){
        if (recognizer.state == .recognized) {
            //since the view is now changed, get rid of all preexisting subviews
            for view in contentView.subviews {
                view.removeFromSuperview()
            }
            if(recognizer.edges == .left) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.contentView.center.x += self.contentView.frame.width
                })
                //If the page is at Sunday, swiping left should get you to Saturday
                if (currDay == DaysInAWeek.Sunday)
                {
                    currDay = DaysInAWeek.Saturday
                }
                else
                {
                    let newDay = currDay.rawValue - 1
                    currDay = DaysInAWeek(rawValue: newDay)!
                }
                daySelected.selectedSegmentIndex = currDay.rawValue - 1 //change segment value as well
                populateStackView()
                contentView.center.x -= contentView.frame.width
            }
            if(recognizer.edges == .right) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.contentView.center.x -= self.contentView.frame.width
                })
                //If the page is at Saturday, swiping right should get you to Sunday
                if (currDay == DaysInAWeek.Saturday) {
                    currDay = DaysInAWeek.Sunday
                }
                else
                {
                    let newDay = currDay.rawValue + 1
                    currDay = DaysInAWeek(rawValue: newDay)!
                }
                daySelected.selectedSegmentIndex = currDay.rawValue - 1 //change segment value as well
                populateStackView()
                contentView.center.x += contentView.frame.width
            }
            //Recenter contentview since it changed from swiping
        }
    }
    
    
    //Function for populating the exercise tiles
    //TODO: there's some magic numbers in here, should consider using constants (or 'let' in this newfangled language???)
    func populateStackView() {
        let exerciseArrayCount = DataHandler.getExerciseArrayCount()
        if (exerciseArrayCount == 0) {
            //Display Placeholder Exercise Tile
            print("Works")
        } else {
            //Populate Exercise Tiles
            let exerciseArray = DataHandler.getExerciseArray()
            for elem in exerciseArray {
                
                let frame = CGRect(x: 0, y: CGFloat(contentView.subviews.count) * 85, width: scrollView.bounds.width, height: TILE_HEIGHT)
                
                //Only grab exercises corresponding to the current day to be displayed
                if (elem.day == currDay)
                {
                    if (elem.getType() == .Cardio) {
                        let tile = CardioTileView(frame: frame, name: elem.exerciseName, time: (elem as! CardioExercise).time, speed: (elem as! CardioExercise).speed, resistance: (elem as! CardioExercise).resistance)
                        tile.tag = CATEGORY_CARDIO_VIEW_TAG
                        let tapGesture = UITapGestureRecognizer(target: self, action:  #selector (self.showPopup(_:)))
                        tile.addGestureRecognizer(tapGesture)
                        
                        contentView.addSubview(tile)
                    } else {
                        let tile = StrengthTileView(frame: frame, name: elem.exerciseName, sets: (elem as! StrengthExercise).sets, reps: (elem as! StrengthExercise).reps)
                        tile.tag = CATEGORY_STRENGTH_VIEW_TAG
                        let tapGesture = UITapGestureRecognizer(target: self, action:  #selector (self.showPopup(_:)))
                        tile.addGestureRecognizer(tapGesture)
                        
                        contentView.addSubview(tile)
                    }
                }
            }
        }
    }
    func setupBarChart()
    {
        barChart.backgroundColor = UIColor.white
        barChart.delegate = self
        barChart.dataSource = self
        barChart.minimumValue = 0
        barChart.maximumValue = CGFloat(chartData.max()!) //Max value of a bar in the graph is the max value from the data array.
        //The height of each bar is relative to this value
        
        //NOTE: footer and header created below reduce size/space of the actual bar graph.
        
        //Creating a footer with appropriate Day labels. Spacing is hard coded unfortunately
        let footer = UILabel(frame: CGRect(x: 0, y: 0, width: barChart.frame.width, height: 16))
        footer.textColor = UIColor.black
        footer.text = "  \(chartLegend[0])     \(chartLegend[1])     \(chartLegend[2])    \(chartLegend[3])    \(chartLegend[4])    \(chartLegend[5])        \(chartLegend[6])"
        footer.textAlignment = NSTextAlignment.left
        
        //Creating a header.
        let header = UILabel(frame: CGRect(x: 0, y: 0, width: barChart.frame.width, height: 16))
        header.textColor = UIColor.black
        header.text = "Workout Completion Chart"
        header.textAlignment = NSTextAlignment.center
        
        barChart.footerView = footer
        barChart.headerView = header
        barChart.reloadData()
        barChart.setState(.collapsed, animated: false)
    }
    
    func hideChart() {
        barChart.setState(.collapsed, animated: true)
    }
    
    func showChart() {
        barChart.setState(.expanded, animated: true)
    }
    
    
    func numberOfBars(in barChartView: JBBarChartView!) -> UInt {
        return UInt(chartData.count)
    }
    
    func barChartView(_ barChartView: JBBarChartView!, heightForBarViewAt index: UInt) -> CGFloat {
        return CGFloat(chartData[Int(index)])
    }
    
    func barChartView(_ barChartView: JBBarChartView!, colorForBarViewAt index: UInt) -> UIColor! {
        return SFURed
        
    }
    
    func barChartView(_ barChartView: JBBarChartView!, didSelectBarAt index: UInt) {
        let data = chartData[Int(index)]
        let key = chartLegend[Int(index)]
        
        informationLabel.text = "Workouts completed on \(key): \(data)"
        //Maybe change the bar graphs to a percentage, so that if all workouts are completed on that day, the bar is a maximum height.
    }

}

