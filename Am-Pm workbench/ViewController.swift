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
                
        let refClock = Clock(clockString: "12:36 am")
        let clockStrings = ["7:45", "8:45", "9:45", "10:45", "11:45", "12:45", "1:45", "2:45", "3:45", "4:45", "5:45", "6:45"]
        var inputClocks = [Clock]()
        
        for i in 0 ..< clockStrings.count {
            inputClocks.append(Clock(clockString: clockStrings[i]))
        }
        
        print("--------  ~ ------ -> -------")
        for iClock in inputClocks {
            if let tClock = refClock.translateAmbiguousClock(iClock) {
                print("\(refClock)  ~ \(iClock) -> \(tClock)")
            } else {
                print("\(refClock)  ~ \(iClock) -> *FAIL*")
            }
        }
    }
}

