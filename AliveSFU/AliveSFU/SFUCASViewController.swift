//
//  SFUCASViewController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-12.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class SFUCASViewController: UIViewController {
    @IBOutlet weak var webContainer: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadCAS()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCAS() {
        // TODO - Talk to SFU IT to get registerd
        
        let url = URL(string: "https://cas.sfu.ca/cas/login?service=http://my/url")
        let req = URLRequest(url: url!)
        
    }
    
}
