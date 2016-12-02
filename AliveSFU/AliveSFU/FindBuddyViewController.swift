//
//  FindBuddyViewController.swift
//  AliveSFU
//
//  Created by Jim on 2016-12-02.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class FindBuddyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var cells = [firebaseProfile]()
    let firebaseManager = firebaseController()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        firebaseManager.returnClosestMatch(weight: 3, function: self.reloadData)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "ProfileCell")
        cell.detailTextLabel?.text = String(cells[indexPath.row].hashNum)
        cell.textLabel?.text = cells[indexPath.row].userName
        return cell
    }
    
    //function that handles reloading of table view when firebase profiles are fetched
    func reloadData(arr : [firebaseProfile]) {
        cells = arr
        tableView.reloadData()
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
