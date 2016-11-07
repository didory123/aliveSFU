//
//  CardioTileView.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-01.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class CardioTileView: UIView {
    
    var uuid : String = ""
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var resistance: UILabel!
    @IBOutlet weak var time: UILabel!

    let TILE_HEIGHT = CGFloat(20);
    let PADDING = CGFloat(20);

    override init(frame: CGRect) {
        super.init(frame: frame);
        //Bundle.main.loadNibNamed("CardioTileViewUI", owner: self, options: nil);

        //self.addSubview(view);    // adding the top level view to the view hierarchy
    }
    
    init(frame: CGRect, name: String, time: String, speed: String, resistance: String) {
        //super.init(frame:UIScreen.main.bounds)
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("CardioTileViewUI", owner: self, options: nil);
        self.addSubview(view);    // adding the top level view to the view hierarchy
        
        self.exerciseName.text = name;
        self.speed.text = speed;
        self.resistance.text = resistance;
        self.time.text = time;
    }
    
    override func didMoveToSuperview() {
        if (superview != nil) {
            let yC = superview!.frame.origin.y + (TILE_HEIGHT * CGFloat(superview!.subviews.count - 1))
        
           // view.frame = CGRect(x: superview!.frame.origin.x, y: yC, width: self.frame.width, height: TILE_HEIGHT)
           // self.frame = CGRect(x: superview!.frame.origin.x, y: yC, width: self.frame.width, height: TILE_HEIGHT)
           // print("XCoord:", yC, " Count: ", superview!.subviews.count, " Height:", view.frame.height)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
}
