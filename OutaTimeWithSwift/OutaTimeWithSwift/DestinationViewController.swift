//
//  DestinationViewController.swift
//  OutaTimeWithSwift
//
//  Created by Donny Davis on 5/12/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

protocol DestinationDateSelectionDelegate: class {
    func selectedDestinationDate(date: NSDate)
}

//enum ImportantDates: String {
//    case Custom
//    case DeclarationOfIndependence = "07/04/1776"
//    case KennedyAssassination = "11/22/1963"
//    case MoonLanding = "07/20/1969"
//    case StarWarsRelease = "05/25/1977"
//    case BackToTheFutureRelease = "07/03/1985"
//    case FluxCapacitorCreated = "11/12/1955"
//    
//    static var count: Int = {return ImportantDates.StarWarsRelease.hashValue + 1}()
//}

class DestinationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //
    // MARK: Properties
    //
    
    @IBOutlet weak var destinationDatePicker: UIDatePicker!
    @IBOutlet weak var importantDatePicker: UIPickerView!
    
    weak var delegate: DestinationDateSelectionDelegate?
    
    let importantDatesArray = ["", "07041776", "11221963", "07201969", "05251977", "07031985", "11121955"]
    let importantDatesLabelArray = ["Custom", "Declaration of Independence", "Kennedy Assassination", "Moon Landing", "Star Wars Release", "Back to the Future Release", "Flux Capacitor Created"]

    //
    // MARK: View Lifecycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        importantDatePicker.delegate = self
        importantDatePicker.dataSource = self

//        destinationDatePicker.performSelector(Selector("setHighlightsToday:"), withObject:UIColor.whiteColor())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let delegate = delegate {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if !appDelegate.historyArray.contains(destinationDatePicker.date) {
                appDelegate.historyArray.append(destinationDatePicker.date)
            }
            delegate.selectedDestinationDate(destinationDatePicker.date)
        }
    }
    
    
    //
    // MARK: UIPickerViewDataSource
    //
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return importantDatesLabelArray.count
    }
    
    
    //
    // MARK: UIPickerViewDelegate
    //
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return importantDatesLabelArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMddyyyy"
        if importantDatesArray[row] == "" {
            destinationDatePicker.setDate(NSDate(), animated: true)
        } else {
            destinationDatePicker.setDate(dateFormatter.dateFromString(importantDatesArray[row])!, animated: true)
        }
    }

}
