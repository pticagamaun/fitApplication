//
//  GetWorkoutModel.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 04.04.2023.
//

import Foundation

struct GetWorkoutModel {
    var workoutArray = [WorkoutModel]()
    mutating func getWorkouts(date: Date) {
        let weekday = date.getWeekdayNumber()
        let startDay = date.dateEndStart().0
        let endDay = date.dateEndStart().1
        let predicateRepeat = NSPredicate(format: "workoutNumberOfDay = \(weekday) AND workoutRepeat = true")
        let predicateUnRepeat = NSPredicate(format: "workoutRepeat = false AND workoutDate BETWEEN %@", [startDay, endDay])
        let compoundPredicate = NSCompoundPredicate(type: .or, subpredicates: [predicateRepeat, predicateUnRepeat])
        let resultsArray = RealmManager.shared.getWorkoutModelResults()
        let filtredArray = resultsArray.filter(compoundPredicate).sorted(byKeyPath: "workoutName")
        workoutArray = filtredArray.map{$0}
    }
}
