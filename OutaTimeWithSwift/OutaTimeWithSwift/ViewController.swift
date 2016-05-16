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
    
    var speedometer = NSTimer()
    
    var currentSpeed: Int? {
        willSet {
            if let value = newValue {
                currentSpeedLabel.text = "\(value) MPH"
                
                if value == 88 {
                    departedTimeLabel.text = presentTimeLabel.text!
                    presentTimeLabel.text = destinationTimeLabel.text!
                }
            } else {
                currentSpeedLabel.text = "0 MPH"
            }
        }
    }

    
    //
    // MARK: View Lifecycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        destinationTimeLabel.text = "--- -- ----"
        departedTimeLabel.text = "--- -- ----"
        presentTimeLabel.text = NSDate().convertToStringWithStyle(Date.dateFormatter, style: .MediumStyle)
        
        currentSpeed = 0
        
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
        if let newHistoryDate = Date(title: "", date: destinationTimeLabel.text?.convertToDateWithFormat(Date.dateFormatter, format: "MMM dd, yyyy")) {
            Date.addHistoryDate(newHistoryDate)
        }
        
        timerOperations(.Start, interval: 0.1, selector: #selector(ViewController.increaseSpeed))
    }
    
    func increaseSpeed() {
        switch currentSpeed! {
        case 0..<88:
            currentSpeed! += 1
            
        case 88:
            timerOperations(.Stop, interval: nil, selector: nil)
            view.backgroundColor = UIColor.whiteColor()
            timerOperations(.Start, interval: 0.3, selector: #selector(ViewController.decreaseSpeed))
            
        default:
            break
        }
    }
    
    func decreaseSpeed() {
        if currentSpeed! == 88 {
            view.backgroundColor = UIColor(red: (54/255.0), green: (54/255.0), blue: (54/255.0), alpha: 1.0)
        }
        
        switch currentSpeed! {
        case 2...88:
            currentSpeed! -= 2
            
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
    // MARK: DestinationDateSelectionDelegate
    //
    
    func selectedDestinationDate(date: NSDate) {
        navigationController?.popViewControllerAnimated(true)
        destinationTimeLabel.text = date.convertToStringWithStyle(Date.dateFormatter, style: .MediumStyle)
        
        if let dateResult = presentTimeLabel.text?.convertToDateWithFormat(Date.dateFormatter, format: "MMM dd, yyyy")?.compare(date) {
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

}