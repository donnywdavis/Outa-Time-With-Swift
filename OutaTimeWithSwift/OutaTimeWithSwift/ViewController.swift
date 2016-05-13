//
//  ViewController.swift
//  OutaTimeWithSwift
//
//  Created by Donny Davis on 5/12/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

//
// MARK: enums
//

enum DateLabels {
    case DestinationTime
    case PresentTime
    case DepartedTime
}

enum TimerOperations {
    case Start
    case Stop
}


class ViewController: UIViewController, DestinationDateSelectionDelegate {
    
    //
    // MARK: Properties
    //
    
    @IBOutlet weak var destinationTimeLabel: UILabel!
    @IBOutlet weak var presentTimeLabel: UILabel!
    @IBOutlet weak var departedTimeLabel: UILabel!
    @IBOutlet weak var currentSpeedLabel: UILabel!
    @IBOutlet weak var setDestinationButton: UIButton!
    @IBOutlet weak var travelBackButton: UIButton!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var speedometer = NSTimer()
    var dateFormatter = NSDateFormatter()
    var currentSpeed = 0

    
    //
    // MARK: View Lifecycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .MediumStyle
        
        setDateLabels(.DestinationTime, date: "--- -- ----")
        setDateLabels(.PresentTime, date: dateFormatter.stringFromDate(NSDate()))
        setDateLabels(.DepartedTime, date: "--- -- ----")
        
        currentSpeed = 0
        setSpeedLabel(currentSpeed)
        
        travelBackButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //
    // MARK: Navigation
    //
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DestinationSegue" {
            let destinationVC = segue.destinationViewController as? DestinationViewController
            destinationVC?.delegate = self
        }
    }
    

    //
    // MARK: Button Actions
    //
    
    @IBAction func travelBack(sender: UIButton) {
        if !appDelegate.historyArray.contains(dateFormatter.stringFromDate(date)) {
            appDelegate.historyArray.append(dateFormatter.stringFromDate(date))
        }
        
        timerOperations(.Start, interval: 0.1, selector: #selector(ViewController.increaseSpeed))
    }
    
    func increaseSpeed() {
        switch currentSpeed {
        case 0..<88:
            currentSpeed += 1
            setSpeedLabel(currentSpeed)
            
        case 88:
            timerOperations(.Stop, interval: nil, selector: nil)
            view.backgroundColor = UIColor.whiteColor()
            setDateLabels(.DepartedTime, date: presentTimeLabel.text!)
            setDateLabels(.PresentTime, date: destinationTimeLabel.text!)
            timerOperations(.Start, interval: 0.2, selector: #selector(ViewController.decreaseSpeed))
            
        default:
            break
        }
    }
    
    func decreaseSpeed() {
        if currentSpeed == 88 {
            view.backgroundColor = UIColor(red: (54/255.0), green: (54/255.0), blue: (54/255.0), alpha: 1.0)
        }
        
        switch currentSpeed {
        case 2...88:
            currentSpeed -= 2
            setSpeedLabel(currentSpeed)
            
        case 0:
            timerOperations(.Stop, interval: nil, selector: nil)
            
        default:
            break
        }
    }
    
    
    //
    // MARK: Time Functions
    //
    
    func timerOperations(operation: TimerOperations, interval: Double?, selector: Selector?) {
        switch operation {
        case .Start:
            guard let interval = interval, let selector = selector else {
                return
            }
            speedometer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: selector, userInfo: nil, repeats: true)
            
        case .Stop:
            speedometer.invalidate()
        }
    }
    
    
    //
    // MARK: Label Utilities
    //
    
    func setDateLabels(label: DateLabels, date: String) {
        switch label {
        case .DestinationTime:
            destinationTimeLabel.text = date
            
        case .PresentTime:
            presentTimeLabel.text = date
            
        case .DepartedTime:
            departedTimeLabel.text = date
        }
    }
    
    func setSpeedLabel(speed: Int) {
        currentSpeedLabel.text = "\(speed) MPH"
    }
    
    
    //
    // MARK: DestinationDateSelectionDelegate
    //
    
    func selectedDestinationDate(date: NSDate) {
        setDateLabels(.DestinationTime, date: dateFormatter.stringFromDate(date))
        
        let dateResult: NSComparisonResult = (dateFormatter.dateFromString(presentTimeLabel.text!)?.compare(date))!
        
        switch dateResult {
        case NSComparisonResult.OrderedSame:
            travelBackButton.enabled = false
            
        case NSComparisonResult.OrderedAscending:
            travelBackButton.setTitle("TRAVEL FORWARD", forState: UIControlState.Normal)
            travelBackButton.enabled = true
            
        case NSComparisonResult.OrderedDescending:
            travelBackButton.setTitle("TRAVEL BACK", forState: UIControlState.Normal)
            travelBackButton.enabled = true
        }
    }

}