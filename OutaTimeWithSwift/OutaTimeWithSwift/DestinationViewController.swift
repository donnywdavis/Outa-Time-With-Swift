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


class DestinationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //
    // MARK: Properties
    //
    
    @IBOutlet weak var destinationDatePicker: UIDatePicker!
    @IBOutlet weak var customDateView: UIView!
    @IBOutlet weak var datesTableView: UIView!
    @IBOutlet weak var dateSelectionSegmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: DestinationDateSelectionDelegate?
    
    var importantDatesArray = Date.loadImportantDates()
    var historyDatesArray = Date.loadHistoryDates()
    

    //
    // MARK: View Lifecycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customDateView.hidden = false
        datesTableView.hidden = true
        
        tableView.tableFooterView = UIView(frame: CGRectZero)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //
    // MARK: Button Actions
    //
    
    @IBAction func letsGoAction(sender: UIButton) {
        callDelegate(destinationDatePicker.date)
    }
    
    func callDelegate(date: NSDate) {
        if let delegate = delegate {
            delegate.selectedDestinationDate(date)
        }
    }
    
    
    //
    // MARK: Segmented Control Actions
    //
    
    @IBAction func segmentActions(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            customDateView.hidden = false
            datesTableView.hidden = true
        case 1, 2:
            customDateView.hidden = true
            datesTableView.hidden = false
            tableView.reloadData()
        default:
            break
        }
        
    }
    
    
    //
    // MARK: UITableViewDataSource
    //
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        tableView.backgroundView = .None
        let noDatesLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: tableView.frame.size.height))
        noDatesLabel.text = "No Dates To Select Yet"
        noDatesLabel.textAlignment = .Center
        noDatesLabel.textColor = UIColor.whiteColor()
        noDatesLabel.sizeToFit()
        
        switch dateSelectionSegmentControl.selectedSegmentIndex {
        case 1:
            if let arrayCount = historyDatesArray?.count where arrayCount == 0 {
                tableView.backgroundView = noDatesLabel
                tableView.separatorStyle = .None
            }
        case 2:
            if let arrayCount = importantDatesArray?.count where arrayCount == 0 {
                tableView.backgroundView = noDatesLabel
                tableView.separatorStyle = .None
            }
        default:
            break
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch dateSelectionSegmentControl.selectedSegmentIndex {
        case 1:
            if let rowCount = historyDatesArray?.count {
                return rowCount
            } else {
                return 0
            }
        case 2:
            if let rowCount = importantDatesArray?.count {
                return rowCount
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DateCell", forIndexPath: indexPath)
        
        switch dateSelectionSegmentControl.selectedSegmentIndex {
        case 1:
            if let historyDate = historyDatesArray?[indexPath.row] {
                cell.textLabel?.text = historyDate.date?.convertToStringWithStyle(Date.dateFormatter, style: .MediumStyle)
                cell.detailTextLabel?.text = ""
            }
        case 2:
            if let importantDate = importantDatesArray?[indexPath.row] {
                cell.textLabel?.text = importantDate.title
                cell.detailTextLabel?.text = importantDate.date?.convertToStringWithStyle(Date.dateFormatter, style: .MediumStyle)
            }
        default:
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch dateSelectionSegmentControl.selectedSegmentIndex {
        case 1:
            if let historyDate = historyDatesArray?[indexPath.row] {
                callDelegate(historyDate.date!)
            }
        case 2:
            if let importantDate = importantDatesArray?[indexPath.row] {
                callDelegate(importantDate.date!)
            }
        default:
            return
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        switch dateSelectionSegmentControl.selectedSegmentIndex {
        case 1:
            return true
        default:
            return false
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if dateSelectionSegmentControl.selectedSegmentIndex == 1 {
            if editingStyle == UITableViewCellEditingStyle.Delete {
                Date.removeHistoryDate(indexPath)
                historyDatesArray?.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
    }

}
