//
//  TutorialsViewController.swift
//  AliveSFU
//
//  Created by Jim on 2016-11-27.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit
import Foundation
class TutorialsViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var disclaimerLabel: UILabel!
    var searchActive : Bool = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    let dataSourceManager = TutorialExercisesManager()
    var cells = [TutorialExercise]()
    let reuseIdentifier : String = "ExerciseCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        searchBar.delegate = self
        
        //Registering the custom xib cell to be used as a collectionview cell
        collectionView.register(UINib(nibName: "ExerciseCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        //Initially, our data source would be the complete list of exercises
        cells = dataSourceManager.completeExerciseList
        
        //add gesture recognizer to the collection view
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.goToInstructionsPage(_:)))
        self.collectionView.addGestureRecognizer(gesture)
        
        //set margins between the cells
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 177, height: 204)
        layout.minimumInteritemSpacing = 10
        collectionView!.collectionViewLayout = layout
        
        collectionView.reloadData()

    }
    
    //Function that occures when a tap gesture is detected on one of the collection view cells
    func goToInstructionsPage(_ sender : UITapGestureRecognizer) {
        self.view.endEditing(true) // hide keyboard
        if (!cells.isEmpty) {
            let pointInCollectionView: CGPoint = sender.location(in: self.collectionView)
            var selectedIndexPath = collectionView.indexPathForItem(at: pointInCollectionView)
            if (selectedIndexPath != nil) {
                performSegue(withIdentifier: "toInstructionsPageSegue", sender: cells[(selectedIndexPath?.row)!])
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //when the segue to the instructions page happens, send in the cell exercise object as wellß
        if segue.identifier == "toInstructionsPageSegue" {
            let newViewController = segue.destination as! TutorialInstructionsViewController
            newViewController.exercise = (sender as? TutorialExercise)!
        }
    }
    // Set the indexPath of the selected item as the sender for the segue
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ExerciseCell
        cell.configure(exercise: cells[indexPath.row])
        //cell.backgroundColor = UIColor.black
        return cell
    }
    
    // hide keyboard when clicked anywhere else
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Searchbar stuff
extension TutorialsViewController {
    //1
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let ctrl = firebaseController()
        cells = dataSourceManager.returnExercisesByKeyword(line: searchText)
        collectionView.reloadData()
        
    }
    // hide keyboard when search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    // hide keyboard when cancel button clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        cells = dataSourceManager.completeExerciseList
        collectionView.reloadData()
        self.searchBar.resignFirstResponder()
        
        //self.myTableView.reloadData()
    }

    
}

//Class that gets tutorial exercises from stored JSON file
class TutorialExercisesManager {
    var completeExerciseList = [TutorialExercise]() //a complete list of all tutorial exercises parsed from json file
    
    //initializes the complete exercise list
    init() {
        if let jsonData = NSDataAsset(name: "tutorialExercises") {
            let data = jsonData.data
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let array = jsonData as? [Any] {
                for element in array {
                    if let jsonObj = element as? [String: Any] {
                        var newExercise = TutorialExercise()
                        if let name = jsonObj["name"] as? String {
                            newExercise.name = name
                        }
                        if let targetMuscle = jsonObj["targetMuscle"] as? String {
                            newExercise.targetMuscle = targetMuscle
                        }
                        if let equipmentName = jsonObj["equipmentName"] as? String {
                            newExercise.equipmentName = equipmentName
                            
                        }
                        completeExerciseList.append(newExercise)
                    }
                }
            }
        }
    }

    //returns a list of exercisees sorted by the keywords as inputted by the user
    func returnExercisesByKeyword(line : String) -> [TutorialExercise] {
        var newExerciseList = [TutorialExercise]()
        for exercise in completeExerciseList {
            if (exercise.contains(keyword: line))
            {
                newExerciseList.append(exercise)
                
            }
        }
        //return new array
        return newExerciseList
    }
}

//Class defining a tutorial exercise
class TutorialExercise {
    var name: String = ""
    var equipmentName: String = ""
    var targetMuscle : String = ""
    init() {
        
    }
    
    //checking if any of the fields match a user's keyword
    func contains(keyword : String) -> Bool {
        if (name.contains(keyword) || equipmentName.contains(keyword) || targetMuscle.contains(keyword)) {
            return true
        }
        else {
            return false
        }
    }
}
