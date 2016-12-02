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
import UIKit

class DataHandler {
    
    class func initDataHandlerData() {
        let moc = AppDataController().managedObjectContext
        
        // To make sure we have only one user details
        let details = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetails")
        details.predicate = NSPredicate(format: "primaryKey = 1")
        
        do {
            let fetchedResult = try moc.fetch(details) as! [NSManagedObject]
            if (fetchedResult.count == 0) {
                let mo = NSEntityDescription.insertNewObject(forEntityName: "UserDetails", into: moc)
                mo.setValue("1", forKey: "primaryKey")
            }
        } catch {
            print("Error setting details")
        }
        
        let bd = NSFetchRequest<NSFetchRequestResult>(entityName: "BuddyDetails")
        bd.predicate = NSPredicate(format: "primaryKey = 1")
        
        do {
            let fetchedResult = try moc.fetch(bd) as! [NSManagedObject]
            if (fetchedResult.count == 0) {
                let mo = NSEntityDescription.insertNewObject(forEntityName: "BuddyDetails", into: moc)
                mo.setValue("1", forKey: "primaryKey")
                mo.setValue(false, forKey: "profileExists")
            }
        } catch {
            print("Error setting details")
        }
        
        // To make sure we only have one flag entity
        let flag = NSFetchRequest<NSFetchRequestResult>(entityName: "Flags")
        flag.predicate = NSPredicate(format: "primaryKey = 1")
        
        do {
            let fetchedResult = try moc.fetch(flag) as! [NSManagedObject]
            if (fetchedResult.count == 0) {
                let mo = NSEntityDescription.insertNewObject(forEntityName: "Flags", into: moc)
                mo.setValue("1", forKey: "primaryKey")
                mo.setValue(false, forKey: "enableFitnessBuddy")
                mo.setValue(false, forKey: "enableSleep")
                mo.setValue(false, forKey: "profileExists")
                mo.setValue(false, forKey: "userLoggedIn")
            }
        } catch {
            print("Error setting flags")
        }
        
        let sa = NSFetchRequest<NSFetchRequestResult>(entityName: "SleepAnalysis")
        sa.predicate = NSPredicate(format: "primaryKey = 1")
        
        do {
            let fetchedResult = try moc.fetch(sa) as! [NSManagedObject]
            if (fetchedResult.count == 0) {
                let mo = NSEntityDescription.insertNewObject(forEntityName: "SleepAnalysis", into: moc)
                mo.setValue("1", forKey: "primaryKey")
                mo.setValue(0, forKey: "sunday")
                mo.setValue(0, forKey: "monday")
                mo.setValue(0, forKey: "tuesday")
                mo.setValue(0, forKey: "wednesday")
                mo.setValue(0, forKey: "thursday")
                mo.setValue(0, forKey: "friday")
                mo.setValue(0, forKey: "saturday")
            }
        } catch {
            print("Error setting sleep analysis weekly data")
        }
        
        do {
            try moc.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
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
    
    class func markExerciseCompleted(id: String, value: Bool) {
        
        let moc = AppDataController().managedObjectContext
        
        //get access to Exercise entity
        let entityFetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        let predicate = NSPredicate(format: "id = %@", id)
        
        //now entityFetch req will contain only those elements that match the predicate condition
        entityFetchReq.predicate = predicate
        
        do {
            //get exerciseArray element where exercise id matched
            var fetchedResult = try moc.fetch(entityFetchReq) as! [NSManagedObject]
            let mo = fetchedResult[0]
            mo.setValue(value, forKey: "completed")
            
            try moc.save()
        }
        catch {
            fatalError("Failed to fetch element! Error: \(error)")
        }
        
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
    
    class func saveProfile(pd: PersonalDetails, fd: FitnessDetails, enableSleep: Bool, enableFitnessBuddy: Bool) -> Int {
        
        let moc = AppDataController().managedObjectContext
        
        // To make sure we have only one user details
        let details = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetails")
        details.predicate = NSPredicate(format: "primaryKey = 1")
        
        do {
            var fetchedResult = try moc.fetch(details) as! [NSManagedObject]
            let mo = fetchedResult[0]
            
            mo.setValue(pd.firstName, forKey: "firstName")
            mo.setValue(pd.lastName, forKey: "lastName")
            mo.setValue(pd.phoneNumber, forKey: "phoneNumber")
            mo.setValue(pd.gender, forKey: "gender")
            mo.setValue(pd.email, forKey: "email")
            
            mo.setValue(fd.ageGroup, forKey: "ageGroup")
            mo.setValue(fd.fitnessFreq, forKey: "frequency")
            mo.setValue(fd.heightFeet, forKey: "heightFeet")
            mo.setValue(fd.heightInches, forKey: "heightInches")
            mo.setValue(fd.personalGoals, forKey: "personalGoals")
            mo.setValue(fd.weight, forKey: "weight")
        } catch {
            print("Error setting details")
        }
        
        // To make sure we only have one flag entity
        let flag = NSFetchRequest<NSFetchRequestResult>(entityName: "Flags")
        flag.predicate = NSPredicate(format: "primaryKey = 1")
        
        do {
            var fetchedResult = try moc.fetch(flag) as! [NSManagedObject]
            let mo = fetchedResult[0]
            
            mo.setValue(enableSleep, forKey: "enableSleep")
            mo.setValue(enableFitnessBuddy, forKey: "enableFitnessBuddy")
            mo.setValue(true, forKey: "profileExists")
        } catch {
            print("Error setting flags")
        }
        
        do {
            try moc.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            return -1
        }
        return 0;
    }

    class func getFlags() -> Flags {
        let moc = AppDataController().managedObjectContext
        
        let flag = NSFetchRequest<NSFetchRequestResult>(entityName: "Flags")
        flag.predicate = NSPredicate(format: "primaryKey = 1")
        do {
            let fetchedResults = try moc.fetch(flag) as! [NSManagedObject]
            for result in fetchedResults {
                let enableFitnessBuddy = result.value(forKey: "enableFitnessBuddy") as? Bool
                let enableSleep = result.value(forKey: "enableSleep") as? Bool
                let profileExists = result.value(forKey: "profileExists") as? Bool
                let isUserLoggedIn = result.value(forKey: "userLoggedIn") as? Bool
                
                return Flags(isDataValid: true, profileExists: profileExists, isUserLoggedIn: isUserLoggedIn, enableFitnessBuddy: enableFitnessBuddy, enableSleepAnalysis: enableSleep)
            }
        } catch {
            fatalError("Failed to fetch array! Error: \(error)")
        }
        
        return Flags.InvalidData
    }
    
    class func setUserLoggedIn(isLoggedIn: Bool) {
        let moc = AppDataController().managedObjectContext
        
        let flag = NSFetchRequest<NSFetchRequestResult>(entityName: "Flags")
        flag.predicate = NSPredicate(format: "primaryKey = 1")
        do {
            let fetchedResults = try moc.fetch(flag) as! [NSManagedObject]
            let mo = fetchedResults[0]
            
            mo.setValue(isLoggedIn, forKey: "userLoggedIn")
        } catch {
            fatalError("Failed to fetch array! Error: \(error)")
        }
        do {
            try moc.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }

    }
    
    class func setSleepAnalysisDataForDay(day: Int, value: Double) {
        var dayOfWeek: String
        switch day {
        case 1:
            dayOfWeek = "sunday"
        case 2:
            dayOfWeek = "monday"
        case 3:
            dayOfWeek = "tuesday"
        case 4:
            dayOfWeek = "wednesday"
        case 5:
            dayOfWeek = "thursday"
        case 6:
            dayOfWeek = "friday"
        case 7:
            dayOfWeek = "saturday"
        default:
            dayOfWeek = "sunday"
        }

        let moc = AppDataController().managedObjectContext
        
        let sa = NSFetchRequest<NSFetchRequestResult>(entityName: "SleepAnalysis")
        sa.predicate = NSPredicate(format: "primaryKey = 1")
        do {
            let fetchedResults = try moc.fetch(sa) as! [NSManagedObject]
            let mo = fetchedResults[0]
            
            mo.setValue(value, forKey: dayOfWeek)
        } catch {
            fatalError("Failed to fetch array! Error: \(error)")
        }
        do {
            try moc.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    class func getSleepAnalysisData() -> [Double] {
        
        var result: [Double] = [0, 0, 0, 0, 0, 0, 0]
        
        let moc = AppDataController().managedObjectContext
        
        let sa = NSFetchRequest<NSFetchRequestResult>(entityName: "SleepAnalysis")
        sa.predicate = NSPredicate(format: "primaryKey = 1")
        do {
            let fetchedResults = try moc.fetch(sa) as! [NSManagedObject]
            let mo = fetchedResults[0]

            result[0] = mo.value(forKey: "sunday") as! Double
            result[1] = mo.value(forKey: "monday") as! Double
            result[2] = mo.value(forKey: "tuesday") as! Double
            result[3] = mo.value(forKey: "wednesday") as! Double
            result[4] = mo.value(forKey: "thursday") as! Double
            result[5] = mo.value(forKey: "friday") as! Double
            result[6] = mo.value(forKey: "saturday") as! Double
           // result = [1,2,3,4,2,1,6] //uncomment for testing purposes
            
        } catch {
            fatalError("Failed to fetch array! Error: \(error)")
        }

        
        return result
    }
    
    class func getPersonalDetails() -> PersonalDetails {
        
        let moc = AppDataController().managedObjectContext
        var pd: PersonalDetails
        
        let details = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetails")
        details.predicate = NSPredicate(format: "primaryKey = 1")
        do {
            let fetchedResults = try moc.fetch(details) as! [NSManagedObject]
            let mo = fetchedResults[0]
            
            let firstN = mo.value(forKey: "firstName") as! String
            let lastN = mo.value(forKey: "lastName") as! String
            let phone = mo.value(forKey: "phoneNumber") as! String
            let gender = mo.value(forKey: "gender") as! Int
            let email = mo.value(forKey: "email") as! String
            
            pd = PersonalDetails(firstName: firstN, lastName: lastN, gender: gender, phoneNumber: phone, email: email)
            
        } catch {
            fatalError("Failed to fetch array! Error: \(error)")
        }
        return pd
    }
    
    class func getFitnessDetails() -> FitnessDetails {
        
        let moc = AppDataController().managedObjectContext
        var fd: FitnessDetails
        
        let details = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetails")
        details.predicate = NSPredicate(format: "primaryKey = 1")
        do {
            let fetchedResults = try moc.fetch(details) as! [NSManagedObject]
            let mo = fetchedResults[0]
            
            let ageGr = mo.value(forKey: "ageGroup") as! Int
            let freq = mo.value(forKey: "frequency") as! Int
            let heightFt = mo.value(forKey: "heightFeet") as! Int
            let heightIn = mo.value(forKey: "heightInches") as! Int
            let weight = mo.value(forKey: "weight") as! Double
            let personalGoals = mo.value(forKey: "personalGoals") as! String
            
            fd = FitnessDetails(heightFeet: heightFt, heightInches: heightIn, weight: weight, ageGroup: ageGr, fitnessFreq: freq, personalGoals: personalGoals)
            
        } catch {
            fatalError("Failed to fetch array! Error: \(error)")
        }
        return fd
    }
    
    class func updateProfile(pd: PersonalDetails, fd: FitnessDetails) {
        let moc = AppDataController().managedObjectContext
        
        // To make sure we have only one user details
        let details = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetails")
        details.predicate = NSPredicate(format: "primaryKey = 1")
        
        do {
            var fetchedResult = try moc.fetch(details) as! [NSManagedObject]
            let mo = fetchedResult[0]
            
            mo.setValue(pd.firstName, forKey: "firstName")
            mo.setValue(pd.lastName, forKey: "lastName")
            mo.setValue(pd.phoneNumber, forKey: "phoneNumber")
            mo.setValue(pd.gender, forKey: "gender")
            mo.setValue(pd.email, forKey: "email")
            
            mo.setValue(fd.ageGroup, forKey: "ageGroup")
            mo.setValue(fd.fitnessFreq, forKey: "frequency")
            mo.setValue(fd.heightFeet, forKey: "heightFeet")
            mo.setValue(fd.heightInches, forKey: "heightInches")
            mo.setValue(fd.personalGoals, forKey: "personalGoals")
            mo.setValue(fd.weight, forKey: "weight")
        } catch {
            print("Error setting details")
        }
        do {
            try moc.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}

//MARK : Fitness Buddy 
extension DataHandler {
    class func saveBuddyProfile(bd: BuddyDetails) -> Int {
        
        let moc = AppDataController().managedObjectContext
        
        // To make sure we have only one user details
        let details = NSFetchRequest<NSFetchRequestResult>(entityName: "BuddyDetails")
        details.predicate = NSPredicate(format: "primaryKey = 1")
        
        do {
            var fetchedResult = try moc.fetch(details) as! [NSManagedObject]
            let mo = fetchedResult[0]
            
            mo.setValue(bd.gender, forKey: "gender")
            mo.setValue(bd.ageGroup, forKey: "ageGroup")
            mo.setValue(bd.fitnessFreq, forKey: "frequency")
            mo.setValue(bd.personalGoals, forKey: "personalGoals")
            mo.setValue(true, forKey: "profileExists")
        } catch {
            print("Error setting details")
        }
        
        do {
            try moc.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            return -1
        }
        return 0;
    }
    
    class func updateBuddyProfile(bd: BuddyDetails) {
        let moc = AppDataController().managedObjectContext
        
        // To make sure we have only one user details
        let details = NSFetchRequest<NSFetchRequestResult>(entityName: "BuddyDetails")
        details.predicate = NSPredicate(format: "primaryKey = 1")
        
        do {
            var fetchedResult = try moc.fetch(details) as! [NSManagedObject]
            let mo = fetchedResult[0]
            
            mo.setValue(bd.gender, forKey: "gender")
            mo.setValue(bd.ageGroup, forKey: "ageGroup")
            mo.setValue(bd.fitnessFreq, forKey: "frequency")
            mo.setValue(bd.personalGoals, forKey: "personalGoals")
        } catch {
            print("Error setting details")
        }
        do {
            try moc.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    class func getBuddyDetails() -> BuddyDetails {
        
        let moc = AppDataController().managedObjectContext
        var bd: BuddyDetails
        
        let details = NSFetchRequest<NSFetchRequestResult>(entityName: "BuddyDetails")
        details.predicate = NSPredicate(format: "primaryKey = 1")
        do {
            let fetchedResults = try moc.fetch(details) as! [NSManagedObject]
            let mo = fetchedResults[0]
            
            let gender = mo.value(forKey: "gender") as! Int
            let ageGr = mo.value(forKey: "ageGroup") as! Int
            let freq = mo.value(forKey: "frequency") as! Int
            let personalGoals = mo.value(forKey: "personalGoals") as! String
            
            bd = BuddyDetails(ageGroup: ageGr, fitnessFreq: freq, personalGoals: personalGoals, gender: gender)
            
        } catch {
            fatalError("Failed to fetch array! Error: \(error)")
        }
        return bd
    }
    
    class func doesBuddyProfileExist() -> Bool {
        let moc = AppDataController().managedObjectContext
        
        let details = NSFetchRequest<NSFetchRequestResult>(entityName: "BuddyDetails")
        details.predicate = NSPredicate(format: "primaryKey = 1")
        do {
            let fetchedResults = try moc.fetch(details) as! [NSManagedObject]
            let mo = fetchedResults[0]
            
            let profileExists = mo.value(forKey: "profileExists") as! Bool
            
            return profileExists
        } catch {
            fatalError("Failed to fetch array! Error: \(error)")
        }
        return false
    }
}

//MARK : Firebase Stuff
extension DataHandler {
    class func getPushID() -> String {
        
        let moc = AppDataController().managedObjectContext
        
        let details = NSFetchRequest<NSFetchRequestResult>(entityName: "FirebaseProfile")
        details.predicate = NSPredicate(format: "primaryKey = 1")
        do {
            let fetchedResults = try moc.fetch(details) as! [NSManagedObject]
            let mo = fetchedResults[0]
            
            return mo.value(forKey: "pushID") as! String
            
        } catch {
            fatalError("Failed to fetch array! Error: \(error)")
        }
    }
    class func setPushID(pushID : String) {
        
        let moc = AppDataController().managedObjectContext
        
        let fb = NSEntityDescription.insertNewObject(forEntityName: "FirebaseProfile", into: moc)
        fb.setValue(pushID, forKey: "pushID")
        do {
            try moc.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
