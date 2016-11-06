//
//  Exercise.swift
//  AliveSFU
//
//  Created by Gagan Kaur on 2016-10-29.
//  Developers: Gur Kohli, Vivek Sharma
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import Foundation

//Using enum to define the days in a week to avoid 'magic numbers'
//The ordering convention follows the Swift NSDate weekday enumeration
public enum DaysInAWeek : Int
{
    case Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
    var name : String {
        switch self {
        // Use Internationalization, as appropriate.
        case .Sunday: return "Sunday";
        case .Monday: return "Monday";
        case .Tuesday: return "Tuesday";
        case .Wednesday: return "Wednesday";
        case .Thursday: return "Thursday";
        case .Friday: return "Friday";
        case .Saturday: return "Saturday";
        }
    }
}

class Exercise {
    var exerciseName: String = ""
    var sets: String = ""
    var reps: String = ""
    var resistance: String = ""
    var speed: String = ""
    var time: String = ""
    var category: String = ""
    var day: Int = DaysInAWeek.Sunday.rawValue
    
    let CATEGORY_CARDIO = "cardio"
    let CATEGORY_STRENGTH = "strength"
    
    init() {
        
    }
    
    init(name: String, sets: String, reps: String) {
        self.exerciseName = name
        self.sets = sets
        self.reps = reps
        self.category = CATEGORY_STRENGTH
    }
    
    init(name: String, time: String, resistance: String?, speed: String?) {
        self.exerciseName = name
        self.time = time
        self.category = CATEGORY_CARDIO
        if ((resistance) != nil) {self.resistance = resistance!}
        if ((speed) != nil) {self.speed = speed!}
    }
    
    //Setters
    public func setName(name: String)
    {
        exerciseName = name
    }
    
    public func setSets(sets1: String)
    {
        sets = sets1
    }
    
    public func setReps(reps1: String)
    {
        reps = reps1
    }
    
    public func setTime(time1: String)
    {
        time = time1
    }
    
    public func setResistance(resistance1: String)
    {
        resistance = resistance1
    }

    public func setDay(day: DaysInAWeek)
    {
        self.day = day.rawValue
    }
    
    //getters
    public func printName()
    {
        print(exerciseName)
    }
    
    public func printSets()
    {
        print(sets)
    }
    
    public func printReps()
    {
        print(reps)
    }
    public func printSpeed()
    {
        print(speed)
    }
    
    public func printTime()
    {
        print(time)
    }
    
    public func printResistance()
    {
        print(resistance)
    }
    public func getDay() -> Int
    {
        return day
    }
    
    
}
