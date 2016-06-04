//
//  ViewController.swift
//  Am-Pm workbench
//
//  Created by John Pavley on 6/3/16.
//  Copyright © 2016 Epic Loot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //let testTime1 = stringToSimpleTime(wallClockTimeString1)
        //print("testTime1: \(testTime1!)")
        //
        //let testTime2 = stringToSimpleTime(inputTimeString1)
        //print("testTime1: \(testTime2!)")
        //
        //let testTime3 = calcTimePeriod(testTime2!, referenceTime: testTime1!)
        
        let inputTimes = ["8:45", "9:45", "10:45", "11:45", "12:45",  "1:45",  "2:45",  "3:45", "4:45", "5:45", "6:45", "7:45"]
        let refTime = "8:36 am"
        
        for i in inputTimes {
            if let resultTime = calcTimePeriodStrings(i, referenceTime: refTime) {
                print("input \(i) with ref \(refTime) resulted in \(resultTime)")
            } else {
                print("input \(i) with ref\(refTime) failed")
            }
        }
        
    }
}

