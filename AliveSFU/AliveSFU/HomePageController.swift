//
//  HomePageController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-10-26.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit
import CoreMotion

class HomePageController: UIViewController {

    @IBOutlet weak var stepCount: UILabel!
    @IBOutlet weak var calorieBurned: UILabel!
    @IBOutlet weak var todaySleep: UILabel!
    
   // let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()
    let calendar = NSCalendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendar = NSCalendar.current
        var comps = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        
        let midnight = calendar.date(from: comps)!
        
        if(CMPedometer.isStepCountingAvailable()){
            
            self.pedoMeter.startUpdates(from: midnight) { (data: CMPedometerData?, error) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(error == nil){
                        print("\(data!.numberOfSteps)")
                        self.stepCount.text = "\(data!.numberOfSteps)"
                    }
                })
            }
        }//endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openMyProfile(_ sender: Any) {
    }

}

