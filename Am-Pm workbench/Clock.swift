//
//  Clock.swift
//
//  MIT License
//  Copyright © 2016 John Pavley
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

/// 🕐 A counter with hour and minutes that cycles through periods.
/// Built-in support for 12 clocks with 60 minutes and two periods (am and pm).
/// Supports the case where the period is not specificed and the clock is ambiguous.
class Clock : CustomStringConvertible {
    
    /// Hard coded to a 12 hour clock.
    let hours = 12
    
    /// Hard coded to a 60 minute hour.
    let minutes = 60
    
    /// 12 hour clocks start at 12:00.
    let startHour = 12
    
    /// Hard coded to standard am/pm period cycle.
    /// The question mark singals an ambiguous clock.
    let periodStrings = ["am", "pm", "?"]
    
    /// A number from 1 to 12.
    var currentHour: Int
    
    /// A number from 0 to 60.
    var currentMinute: Int
    
    /// A number from 0 to 2.
    var currentPeriodIndex: Int
    
    /// String representation: "00:00 xx" as in "8:45 am" or "12:01 ?".
    var description: String {
        return "\(currentHour):\(currentMinute) \(periodStrings[currentPeriodIndex])"
    }
    
    /// A clock is ambiguous if no period is specified.
    var ambiguous: Bool {
        if currentPeriodIndex == 2 {
            return true
        } else {
            return false
        }
    }
    
    // MARK: -
    
    /// Init that sets the clock to a specific time.
    // TODO: Error checking!
    init(currentHour: Int, currentMinute: Int, currentPeriodIndex: Int) {
        self.currentHour = currentHour
        self.currentMinute = currentMinute
        self.currentPeriodIndex = currentPeriodIndex
    }
    
    /// Init that sets the clock to match another clock.
    init(clock: Clock) {
        self.currentHour = clock.currentHour
        self.currentMinute = clock.currentMinute
        self.currentPeriodIndex = clock.currentPeriodIndex
    }
    
    /// Init from a string in the format "00:00 xx" or "00:00" (ambiguous).
    // TODO: Error checking!
    init(clockString: String) {
        let normalizedClockString = clockString.lowercaseString
        var workingString = normalizedClockString
        
        if normalizedClockString.containsString("am") || normalizedClockString.containsString("pm") {
            let array1 = normalizedClockString.componentsSeparatedByString(" ")
            let periodString = array1[1]
            if periodString == "am" {
                self.currentPeriodIndex = 0
            } else {
                self.currentPeriodIndex = 1
            }
            workingString = array1[0]
        } else {
            self.currentPeriodIndex = 2
        }
        
        let array2 = workingString.componentsSeparatedByString(":")
        self.currentHour = Int(array2[0])!
        self.currentMinute = Int(array2[1])!
    }
    
    // TODO: init the clock from system time
    // TODO: init the clock to 0:00 am
    
    // MARK: -

    /// Flips the period between am and pm.
    /// If clock is ambiguous period is set to am.
    func flipPeriod() {
        if currentPeriodIndex == 0 {
            currentPeriodIndex = 1
        } else {
            currentPeriodIndex = 0
        }
    }
    
    /// Adds the count number of hours to the clock respectiing the 12 hour cycle and period.
    func incrementHoursBy(count: Int) {
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
    
    /// Returns a clock that is a representation of this clock in terms of a ambiguous clock.
    /// If this clock is "8:45 pm" and the ambigous clock is "8:36" return "8:45 pm".
    /// For clocks without equivalent hours use the 3/8 rule: 3 hours back, 8 hours forward to calc the time period.
    /// For clocks with hours that don't fit the above rules return nil.
    func translateAmbiguousClock(clock: Clock) -> Clock? {
        
        if self.ambiguous {
            return nil
        }
        
//        if self.currentHour == clock.currentHour {
//            return Clock(currentHour: clock.currentHour, currentMinute: clock.currentMinute, currentPeriodIndex: self.currentPeriodIndex)
//        }
        
        var comparisonClocks = [Clock]()
        
        for _ in 0..<12 {
            comparisonClocks.append(Clock(clock: self))
        }
        
        comparisonClocks[0].decrementHoursBy(3)
        comparisonClocks[1].decrementHoursBy(2)
        comparisonClocks[2].decrementHoursBy(1)
        //comparisonClocks[3] nothing to change
        comparisonClocks[4].incrementHoursBy(1)
        comparisonClocks[5].incrementHoursBy(2)
        comparisonClocks[6].incrementHoursBy(3)
        comparisonClocks[7].incrementHoursBy(4)
        comparisonClocks[8].incrementHoursBy(5)
        comparisonClocks[9].incrementHoursBy(6)
        comparisonClocks[10].incrementHoursBy(7)
        comparisonClocks[11].incrementHoursBy(8)
        
//        for (index, comparisonClock) in comparisonClocks.enumerate() {
//            print("\(index) \(comparisonClock)")
//        }
        
        for comparisonClock in comparisonClocks {
            if clock.currentHour == comparisonClock.currentHour {
                return Clock(currentHour: clock.currentHour, currentMinute: clock.currentMinute, currentPeriodIndex: comparisonClock.currentPeriodIndex)
            }
        }
        
        return nil
    }
    
}