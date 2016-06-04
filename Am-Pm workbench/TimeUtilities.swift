//
//  TimeUtilities.swift
//  Am-Pm workbench
//
//  Created by John Pavley on 6/3/16.
//  Copyright © 2016 Epic Loot. All rights reserved.
//

import Foundation

/*:
 ### Assume nearer times can be more accurately guessed than farther times
 - It is more likely that "9:45" is in the AM given a wall clock of "8:36 AM"
 
 ### Assume time marches forward more often than backwards
 - It is more likely that "12:45" in is in the PM given a wall clock of "8:36 AM"
 
 ### Assume distant times can't be predicted so say nothing
 - Given a wall clock of "8:36 AM" it's inpossible to say anything about 3:45"
 
 ### Assume times with the same hour number are in the same period
 - "8:45" is probably "8:45 AM" given a wall clock of "8:36 AM"
 
 ### Assume that 12 noon and 12 midnight are switches that flip from AM to PM and PM to AM
 - Given a wall clock of "10:36 AM" an input time of "12:45" is in the PM
 - given a wall clock of "10:36 PM" an input time of "12:45" is in the AM
 
 ### Assume that crossing 12 Midnight increments the date by one day
 - Given a wall clock of "10:36 PM" an input time of "12:45" is in the AM of the next day
 
 */

//: ### Utilities

/**
 Low budget model of time.
 */
struct SimpleTimeStruc {
    var hour = 0;
    var minute = 0;
    var period = "?"
    var description: String {
        return "\(hour):\(minute) \(period)"
    }
}

/**
 Transfors a string into a SimpleTimeStruc if possible.
 Supports "00:00" and "00:00 xx".
 Doesn't care about 12 hour or 24 hour time.
 */
func stringToSimpleTime(timeString:String) -> SimpleTimeStruc? {
    
    var sts = SimpleTimeStruc()
    let normalizedTimeString = timeString.lowercaseString
    var workingString = normalizedTimeString
    
    // check for the period and parse it if it exists
    if normalizedTimeString.containsString("am") || normalizedTimeString.containsString("pm") {
        let array1 = normalizedTimeString.componentsSeparatedByString(" ")
        sts.period = array1[1]
        workingString = array1[0]
    }
    
    let array2 = workingString.componentsSeparatedByString(":")
    sts.hour = Int(array2[0])!
    sts.minute = Int(array2[1])!
    return sts
}

func calc24HourTimeSum(currentHour: Int, amountToAdd: Int) -> Int {
    var result = currentHour + amountToAdd
    if result > 23 {
        result = result - 24
    }
    return result
}

func calc24HourTimeDiff(currentHour: Int, amountToSub: Int) -> Int {
    var result = currentHour - amountToSub
    if result < 0 {
        result = 24 + result
    }
    return result
}

func convertTo24HourTime(inputTime: SimpleTimeStruc) -> SimpleTimeStruc {
    
    var result = inputTime
    
    if result.hour >= 12 {
        result.period = "?"
        return result
    }
    
    if result.period == "am" {
        result.period = "?"
        return result
    }
    
    result.hour = result.hour + 12
    result.period = "?"
    return result
}

/**
 Returns input time with period based on reference time if possible
 */
func calcTimePeriod(inputTime: SimpleTimeStruc, referenceTime: SimpleTimeStruc) -> SimpleTimeStruc! {
    
    if inputTime.hour == referenceTime.hour {
        return SimpleTimeStruc(hour: inputTime.hour, minute: inputTime.minute, period: referenceTime.period)
    }
    
    let referenceTimeHour24 = convertTo24HourTime(referenceTime)

    var inputTimeHour24 = inputTime
    
    if inputTime.hour == 12 {
        if referenceTimeHour24.hour < 12 {
            inputTimeHour24.period = "am"
        } else {
            inputTimeHour24.period = "pm"
        }
        inputTimeHour24 = convertTo24HourTime(inputTimeHour24)
    }
    
    inputTimeHour24.period = referenceTime.period
    inputTimeHour24 = convertTo24HourTime(inputTimeHour24)
    
    let lowerBounds = calc24HourTimeDiff(referenceTimeHour24.hour, amountToSub: 5)
    let upperBounds = calc24HourTimeSum(referenceTimeHour24.hour, amountToAdd: 10)
    
    if inputTimeHour24.hour >= lowerBounds && inputTimeHour24.hour <= upperBounds {
        return SimpleTimeStruc(hour: inputTime.hour, minute: inputTime.minute, period: referenceTime.period)
    }
    
    return nil
}

func calcTimePeriodStrings(inputTime: String, referenceTime: String) -> String? {
    let t1 = stringToSimpleTime(inputTime)!
    let t2 = stringToSimpleTime(referenceTime)!
    if let t3 = calcTimePeriod(t1, referenceTime: t2) {
        return t3.description
    }
    return nil
}










