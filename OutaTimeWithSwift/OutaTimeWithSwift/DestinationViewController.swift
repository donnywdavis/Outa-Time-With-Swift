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

class DestinationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate {
    
    //
    // MARK: Properties
    //
    
    @IBOutlet weak var destinationDatePicker: UIDatePicker!
    @IBOutlet weak var importantDatePicker: UIPickerView!
    @IBOutlet weak var importantDatesView: UIView!
    @IBOutlet weak var historyView: UIView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    weak var delegate: DestinationDateSelectionDelegate?
    
    let segmentsArray = ["ImportantDatesSegment", "HistorySegment"]
    let importantDatesArray = ["", "07041776", "11221963", "07201969", "05251977", "07031985", "11121955"]
    let importantDatesLabelArray = ["Custom", "Declaration of Independence", "Kennedy Assassination", "Moon Landing", "Star Wars Release", "Back to the Future Release", "Flux Capacitor Created"]

    //
    // MARK: View Lifecycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        importantDatePicker.delegate = self
        importantDatePicker.dataSource = self
        
        historyView.hidden = true
        importantDatesView.hidden = false

//        importantDatePicker.performSelector(#selector("setHighlightsToday:"), withObject:UIColor.whiteColor())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let delegate = delegate {
            delegate.selectedDestinationDate(destinationDatePicker.date)
        }
    }
    
    //
    // MARK: Segmented Control Actions
    //
    
    @IBAction func segmentActions(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            historyView.hidden = true
            importantDatesView.hidden = false
        case 1:
            historyView.hidden = false
            importantDatesView.hidden = true
        default:
            break
        }
        
    }
    
    
    //
    // MARK: UITableViewDataSource
    //
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.historyArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = appDelegate.historyArray[indexPath.row]
        
        return cell
    }
    
    
    //
    // MARK: UITableViewDelegate
    //
    
    
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
