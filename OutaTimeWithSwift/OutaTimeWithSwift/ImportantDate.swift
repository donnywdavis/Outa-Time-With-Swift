//
//  ImportantDate.swift
//  OutaTimeWithSwift
//
//  Created by Donny Davis on 5/15/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

class Date: NSObject {
    let title: String?
    let date: NSDate?
    
    
    //
    // MARK: Initializers
    //
    
    init(title: String?, date: NSDate?) {
        self.title = title
        self.date = date
    }
    
    init?(datesDictionary: [String: String]) {
        guard let title = datesDictionary["title"], let date = datesDictionary["date"] else {
            return nil
        }
        self.title = title
        self.date = Date.convertDateFromString(date, format: "MMddyyyy")
    }
    
    
    //
    // MARK: Class methods
    //
    
    class func convertDateFromString(date: String, format: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        guard let convertedDate = dateFormatter.dateFromString(date) else {
            return nil
        }
        return convertedDate
    }
    
    class func convertDateToStringWithStyle(date: NSDate, style: NSDateFormatterStyle) -> String? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.stringFromDate(date)
    }
    
    class func convertDateToStringWithFormat(date: NSDate, format: String) -> String? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(date)
    }
    
    class func convertDateObjectToDictionary(dateObject: Date) -> [String: String] {
        var newDictionary = [String: String]()
        newDictionary["title"] = dateObject.title
        newDictionary["date"] = Date.convertDateToStringWithFormat(dateObject.date!, format: "MMddyyyy")
        return newDictionary
    }
    
    class func loadImportantDates() -> [Date]? {
        // Load the file
        guard let filePath = NSBundle.mainBundle().pathForResource("important-dates", ofType: "json") else {
            return nil
        }
        let dataArray: [[String: String]]
        do {
            dataArray = try NSJSONSerialization.JSONObjectWithData(NSData.init(contentsOfFile: filePath, options: []), options: .AllowFragments) as! [[String: String]]
        } catch {
            return nil
        }
        
        var datesArray = [Date]()
        for importantDate: [String: String] in dataArray {
            datesArray.append(Date(datesDictionary: importantDate)!)
        }
        
        return datesArray
    }
    
    class func loadHistoryDates() -> [Date]? {
        // Get the path to the documents directory
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        guard let filePath = paths.first?.stringByAppendingString("/history.json") else {
            return nil
        }
     
        let dataArray: [[String: String]]
        do {
            dataArray = try NSJSONSerialization.JSONObjectWithData(NSData.init(contentsOfFile: filePath, options: []), options: .AllowFragments) as! [[String: String]]
        } catch {
            return nil
        }
        
        var datesArray = [Date]()
        for importantDate: [String: String] in dataArray {
            datesArray.append(Date(datesDictionary: importantDate)!)
        }
        
        return datesArray
    }
    
    class func addHistoryDate(historyDate: Date) {
        var historyArray = currentHistory()
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let filePath = paths.first?.stringByAppendingString("/history.json")
        let outputStream = NSOutputStream(toFileAtPath: filePath!, append: false)
        var historyDictionary = [String: String]()
        historyDictionary["title"] = historyDate.title
        historyDictionary["date"] = Date.convertDateToStringWithFormat(historyDate.date!, format: "MMddyyyy")
        historyArray?.append(historyDictionary)
        outputStream?.open()
        NSJSONSerialization.writeJSONObject(historyArray!, toStream: outputStream!, options: .PrettyPrinted, error: nil)
        outputStream?.close()
    }
    
    
    //
    // MARK: Private class methods
    //
    
    private class func currentHistory() -> [[String: String]]? {
        // Get the path to the documents directory
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        guard let filePath = paths.first?.stringByAppendingString("/history.json") else {
            return []
        }
        
        let dataArray: [[String: String]]
        do {
            dataArray = try NSJSONSerialization.JSONObjectWithData(NSData.init(contentsOfFile: filePath, options: []), options: .AllowFragments) as! [[String: String]]
            return dataArray
        } catch {
            return []
        }
    }
    
}
