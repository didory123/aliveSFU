//
//  DataHandler.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-01.
//  Developers: Vivek Sharma, Gagan Kaur
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import Foundation
import CoreData

class DataHandler {
    
    class func getExerciseArrayCount() -> Int{
        let moc = AppDataController().managedObjectContext
        let entityFetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        do {
            let fetchedResults = try moc.fetch(entityFetchReq)
            return fetchedResults.count
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
    
    class func getExerciseArray() -> [Exercise] {
        var exerciseArr = [Exercise]()
        
        let moc = AppDataController().managedObjectContext
        let entityFetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        do {
            let fetchedResults = try moc.fetch(entityFetchReq) as! [NSManagedObject]
            for result in fetchedResults {
                let id = result.value(forKey: "id") as! String
                let name = result.value(forKey: "exerciseName") as! String
                let day = result.value(forKey: "day") as! Int
                let category = result.value(forKey: "category") as! String
                let completed = result.value(forKey : "completed") as! Bool
                //Create an exercise instance
                let newElem = ExerciseFactory.returnExerciseByCategory(type: ExerciseType(rawValue: category)!, exerciseName: name, day: DaysInAWeek(rawValue : day)!, completed: completed, id : id)
                //Being super lazy here, pretty sure actual instantiation logic should happen inside the factory class as well but yolo
                if (category == ExerciseType.Cardio.rawValue)
                {
                    let time = result.value(forKey: "time") as! String
                    let resistance = result.value(forKey: "resistance") as! String
                    let speed = result.value(forKey: "speed") as! String
                    let elem = newElem as! CardioExercise
                    elem.resistance = resistance
                    elem.speed = speed
                    elem.time = time
                }
                else
                {
                    let sets = result.value(forKey: "sets") as! String
                    let reps = result.value(forKey: "reps") as! String
                    let elem = newElem as! StrengthExercise
                    elem.reps = reps
                    elem.sets = sets
                }
                exerciseArr.append(newElem)
            }
            return exerciseArr
        } catch {
            fatalError("Failed to fetch array! Error: \(error)")
        }
        
    }
    
    class func deleteElementFromExerciseArray(id: String) -> Int {
        
        let moc = AppDataController().managedObjectContext
    
        //get access to Exercise entity
        let entityFetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
       
        let predicate = NSPredicate(format: "id = %@",id)
        entityFetchReq.predicate = predicate
       
        do {
            //get exerciseArray element where exerciseName = name
            var fetchedResult = try moc.fetch(entityFetchReq) as! [NSManagedObject]
            try moc.delete(fetchedResult[0])
            try moc.save()
            return 0;
        }
            
        catch {
            fatalError("Failed to fetch element! Error: \(error)")
        }
    }
    
    
    class func deleteExerciseArray() -> Int {
        let moc = AppDataController().managedObjectContext
        let entityFetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        do {
            let fetchedResults = try moc.fetch(entityFetchReq) as! [NSManagedObject]
            for result in fetchedResults {
                moc.delete(result)
            }
            try moc.save()
            
            return 0;
        } catch {
            fatalError("Failed to delete array! Error: \(error)")
        }
    }
    
    
    class func saveElementToExerciseArray(elem: Exercise) -> Int {
        
        let moc = AppDataController().managedObjectContext
        //let entity = NSEntityDescription.entity(forEntityName: "Exercise", in: moc)
        let exercise = NSEntityDescription.insertNewObject(forEntityName: "Exercise", into: moc)
        
        exercise.setValue(elem.id, forKey: "id")
        exercise.setValue(elem.exerciseName, forKey: "exerciseName")
        exercise.setValue(elem.getType().rawValue, forKey: "category")
        exercise.setValue(elem.day.rawValue, forKey: "day")
        exercise.setValue(elem.completed, forKey: "completed")
        //TODO: Might need to refactor again
        //The below could be done better, just running out of time
        if (elem.getType() == .Strength) {
            exercise.setValue((elem as! StrengthExercise).sets, forKey: "sets")
            exercise.setValue((elem as! StrengthExercise).reps, forKey: "reps")
            
        } else {
            exercise.setValue((elem as! CardioExercise).speed, forKey: "speed")
            exercise.setValue((elem as! CardioExercise).resistance, forKey: "resistance")
            exercise.setValue((elem as! CardioExercise).time, forKey: "time")
        }
        
        do {
            try moc.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            return -1
        }
        return 0;
    }
    
    //save changes to exercise array in popover
    //go to exercise array, find the element we are changing and change the attribute to the new one
    class func saveExerciseChanges(elem: Exercise) -> Int {
      
        let moc = AppDataController().managedObjectContext
       
        //get access to Exercise entity
        let entityFetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        let predicate = NSPredicate(format: "id = %@", elem.id)
        
        //now entityFetch req will contain only those elements that match the predicate condition
        entityFetchReq.predicate = predicate
        
        do {
            //get exerciseArray element where exercise id matched
            var fetchedResult = try moc.fetch(entityFetchReq) as! [NSManagedObject]
                let exercise = fetchedResult[0]
                
                // Strength
                if (elem.getType() == ExerciseType.Strength) {
                    exercise.setValue(elem.exerciseName, forKey: "exerciseName")
                    exercise.setValue((elem as! StrengthExercise).sets, forKey: "sets")
                    exercise.setValue((elem as! StrengthExercise).reps, forKey: "reps")
                }
                // Cardio
                else {
                    exercise.setValue(elem.exerciseName, forKey: "exerciseName")
                    exercise.setValue((elem as! CardioExercise).speed, forKey: "speed")
                    exercise.setValue((elem as! CardioExercise).resistance, forKey: "resistance")
                    exercise.setValue((elem as! CardioExercise).time, forKey: "time")
                }

            try moc.save()
            
            }
            
        catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            return -1
        }
        print (">7<")
        
        return 0;
    }
    
    
    //Returns an array 7 integers long with each index holding that day's amount of completed exercises
    //Main use will be in the graph for my progress
    class func countCompletion() -> [Int]
    {
        var dayArray: [Int] = [0, 0, 0, 0, 0, 0, 0]
        let exerciseArray = DataHandler.getExerciseArray()
        for elem in exerciseArray {
            if (elem.completed == true)
            {
                //The days in a week are indexed starting from 1 as per NSDate standards so subtract one
                dayArray[elem.day.rawValue-1] += 1
            }
        }
        return dayArray
    }
}
