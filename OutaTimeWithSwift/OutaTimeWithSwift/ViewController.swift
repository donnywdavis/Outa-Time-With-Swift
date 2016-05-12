//
//  ViewController.swift
//  OutaTimeWithSwift
//
//  Created by Donny Davis on 5/12/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

enum DateLabels {
    case DestinationTime
    case PresentTime
    case DepartedTime
}

class ViewController: UIViewController {
    
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
    // MARK: Button Actions
    //
    
    @IBAction func travelBack(sender: UIButton) {
    }
    
    //
    // MARK: Utilities
    //
    
    func setDateLabels(label: DateLabels, date: String) {
        switch label {
        case .DestinationTime:
            destinationTimeLabel.text = date
        case .PresentTime:
            presentTimeLabel.text = date
        case .DepartedTime:
            destinationTimeLabel.text = date
        }
    }
    
    func setSpeedLabel(speed: Int) {
        currentSpeedLabel.text = "\(speed) MPH"
    }

}

