//
//  AmbiguousClockUtilities.swift
//  Am-Pm workbench
//
//  Created by John Pavley on 6/5/16.
//  Copyright © 2016 Epic Loot. All rights reserved.
//

import Foundation

enum Period: Int {
    case am = 0;
    case pm = 1;
    case ambiguous = 2;
    
}

struct SimpleTime {
    var hour = 0;
    var minute = 0;
    var period = Period.ambiguous
    
    init(hour: Int, minute: Int, period: Period) {
        self.hour = hour
        self.minute = minute
        self.period = period
    }
}

func stringToSimpleTime(timeString: String) -> SimpleTime {
    let normalizedClockString = timeString.lowercaseString
    var workingString = normalizedClockString
    var period: Period, hour: Int, minute: Int
    
    if normalizedClockString.containsString("am") || normalizedClockString.containsString("pm") || normalizedClockString.containsString("?"){
        let array1 = normalizedClockString.componentsSeparatedByString(" ")
        period = stringToPeriod(array1[1])
        workingString = array1[0]
    } else {
        period = Period.ambiguous
    }
    
    let array2 = workingString.componentsSeparatedByString(":")
    hour = Int(array2[0])!
    minute = Int(array2[1])!
    
    return SimpleTime(hour: hour, minute: minute, period: period)
}

func simpleTimeToString(simpleTime: SimpleTime) -> String {
    return "\(simpleTime.hour):\(simpleTime.minute) \(periodToString(simpleTime.period))"
}

func periodToString(period: Period) -> String {
    switch period {
    case Period.am:
        return "am"
    case Period.pm:
        return "pm"
    case Period.ambiguous:
        return ""
    }
}

func stringToPeriod(periodString: String) -> Period {
    if periodString == "?" {
        return Period.ambiguous
    } else if periodString == "am" {
        return Period.am
    } else {
        return Period.pm
    }
}

/// Flips the period between am and pm.
/// If period is ambiguous return ambiguous.
func flipPeriodIndex(currentPeriodIndex: Period) -> Period {
    switch currentPeriodIndex {
    case Period.am:
        return Period.pm
    case Period.pm:
        return Period.am
    case Period.ambiguous:
        return Period.ambiguous
    }
}

/// Adds the count number of hours to the clock respectiing the 12 hour cycle and period.
func incrementHoursBy(count: Int, currentHour:Int) -> Int {
    currentHour += count
    if currentHour == startHour {
        flipPeriod()
    } else if currentHour > startHour {
        currentHour = currentHour - hours
        // FIXME: When I start with 12:xx I want to stay in the same period
        flipPeriod()
    }
}

/// Subtracts the count number of hours to the clock respectiing the 12 hour cycle and period.
func decrementHoursBy(count: Int) {
    currentHour -= count
    if currentHour <= startHour {
        flipPeriod()
    } else if currentHour == 0 {
        currentHour = startHour
        //flipPeriod()
    } else if currentHour < 0 {
        currentHour = hours - abs(currentHour)
        //flipPeriod()
    }
}



