//
//  Exercise.swift
//  AliveSFU
//
//  Created by Gagan Kaur on 2016-10-29.
//  Developers: Gur Kohli, Vivek Sharma
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import Foundation

//Enum for definind the days in a week
public enum DaysInAWeek : Int
{
    //A value of 1 corresponds to Sunday, 0 to Monday and so on to 7 being Saturday (following Swift NSDate indexing)
    case Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
    var name : String {
        switch self {
        case .Sunday: return "Sunday";
        case .Monday: return "Monday";
        case .Tuesday: return "Tuesday";
        case .Wednesday: return "Wednesday";
        case .Thursday: return "Thursday";
        case .Friday: return "Friday";
        case .Saturday: return "Saturday";
        }
    }
    //A value of 1 corresponds to Sunday, 0 to Monday and so on to 7 being Saturday (following Swift NSDate indexing)
    var index : Int {
        switch self {
        // Use Internationalization, as appropriate.
        case .Sunday: return 1;
        case .Monday: return 2;
        case .Tuesday: return 3;
        case .Wednesday: return 4;
        case .Thursday: return 5;
        case .Friday: return 6;
        case .Saturday: return 7;
        }
    }

}

//Utilizing factory pattern for instantiation of exercise type objects
//Pass in a type to get a guaranteed subclass value to avoid trying to cast/guess type at instantiation
public class ExerciseFactory
{
    //Instantiates the right exercise object by category
    static func returnExerciseByCategory(type : ExerciseType, exerciseName : String, day : DaysInAWeek, completed : Bool) -> Exercise
    {
        switch type {
        case .Strength:
            return StrengthExercise(exerciseName : exerciseName, day : day, completed : completed)
        case .Cardio:
            return CardioExercise(exerciseName : exerciseName, day : day, completed : completed)
        }
    }
}

//Defining exercise type, open for extension
public enum ExerciseType : String {
    case Cardio = "Cardio", Strength = "Strength"
}

//Using a protocol type for exercise
//There is a possibility that exercise types will get expanded in the future, using inheritance will open the class up for possible extension
protocol Exercise {
    var exerciseName: String { get set }
    var day: DaysInAWeek { get set }
    var completed: Bool { get set }
    init(exerciseName : String, day : DaysInAWeek, completed : Bool)
    func getType() -> ExerciseType
    
}

//Strength exercise class
class StrengthExercise : Exercise {
    internal var exerciseName: String = ""
    internal var completed : Bool = false
    internal var day : DaysInAWeek = .Sunday
    
    internal var sets : String = ""
    internal var reps : String = ""
    required init(exerciseName : String, day : DaysInAWeek, completed : Bool)
    {
        self.exerciseName = exerciseName
        self.day = day
        self.completed = completed
    }
    func getType() -> ExerciseType {
        return .Strength
    }
}

//Cardio exercise class
class CardioExercise : Exercise {
    internal var exerciseName: String = ""
    internal var completed : Bool = false
    internal var day : DaysInAWeek = .Sunday
    
    internal var time : String = ""
    internal var resistance : String = ""
    internal var speed : String = ""
    required init(exerciseName : String, day : DaysInAWeek, completed : Bool)
    {
        self.exerciseName = exerciseName
        self.day = day
        self.completed = completed
    }
    func getType() -> ExerciseType {
        return .Cardio
    }
}
