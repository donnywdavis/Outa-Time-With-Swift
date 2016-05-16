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
        self.date = Date.convertStringToDate(date, withFormat: "MMddyyyy")
    }
    
    
    //
    // MARK: Class methods
    //
    
    //
    // Convert a string to a date using a specified format
    //
    class func convertStringToDate(date: String, withFormat format: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        guard let convertedDate = dateFormatter.dateFromString(date) else {
            return nil
        }
        return convertedDate
    }
    
    //
    // Convert a date to a string with a specified style
    //
    class func convertDateToString(date: NSDate, withStyle style: NSDateFormatterStyle) -> String? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.stringFromDate(date)
    }
    
    //
    // Convert date to a string using a specified format
    //
    class func convertDateToString(date: NSDate, withFormat format: String) -> String? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(date)
    }
    
    //
    // Unpack a Date object back into a dictionary
    //
    class func convertDateObjectToDictionary(dateObject: Date) -> [String: String] {
        var newDictionary = [String: String]()
        newDictionary["title"] = dateObject.title
        newDictionary["date"] = Date.convertDateToString(dateObject.date!, withFormat: "MMddyyyy")
        return newDictionary
    }
    
    //
    // Load up an array of important dates
    //
    class func loadImportantDates() -> [Date]? {
        // Load the file
        guard let filePath = NSBundle.mainBundle().pathForResource("important-dates", ofType: "json") else {
            return nil
        }
        
        // Unpack the data from the file
        guard let dataArray = unpackFileData(filePath) else {
            return nil
        }
        
        
        // Load up array of Date objects from returned data
        var datesArray = [Date]()
        for importantDate: [String: String] in dataArray {
            datesArray.append(Date(datesDictionary: importantDate)!)
        }
        
        return datesArray
    }
    
    //
    // Load up an array of history dates
    //
    class func loadHistoryDates() -> [Date]? {
        // Get the path to the documents directory
        guard let filePath = getHistoryPath() else {
            return nil
        }
        
        // Unpack the data from the file
        guard let dataArray = unpackFileData(filePath) else {
            return nil
        }
        
        // Load up array of Date objects from returned data
        var datesArray = [Date]()
        for importantDate: [String: String] in dataArray {
            datesArray.append(Date(datesDictionary: importantDate)!)
        }
        
        return datesArray
    }
    
    //
    // Add a date to our history file
    //
    class func addHistoryDate(historyDate: Date) {
        // Get an array of the current history items
        var historyArray = currentHistory()
        
        // Check that we have a file path
        guard let filePath = getHistoryPath() else {
            return
        }
        
        // Create an output stream to write to
        let outputStream = NSOutputStream(toFileAtPath: filePath, append: false)
        
        // Add our new date to the current array
        historyArray?.append(Date.convertDateObjectToDictionary(historyDate))
        
        // Open up the output stream for writing to
        outputStream?.open()
        
        // Write the new date to the file
        NSJSONSerialization.writeJSONObject(historyArray!, toStream: outputStream!, options: .PrettyPrinted, error: nil)
        
        // Close the output stream
        outputStream?.close()
    }
    
    
    //
    // MARK: Private class methods
    //
    
    //
    // Get the path to the history.json file
    //
    private class func getHistoryPath() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        guard let documentsDirectory = paths.first else {
            return nil
        }
        return documentsDirectory.stringByAppendingString("/history.json")
    }
    
    //
    // Get an array of the current history items
    //
    private class func currentHistory() -> [[String: String]]? {
        // Get the history file path
        guard let filePath = getHistoryPath() else {
            return nil
        }
        
        // Unpack the data from the file into an array of dictionaries
        return unpackFileData(filePath)
    }
    
    //
    // Unpack data from file into an array of dictionaries
    //
    private class func unpackFileData(filePath: String) -> [[String: String]]? {
        let dataArray: [[String: String]]
        do {
            guard let fileData = NSData.init(contentsOfFile: filePath) else {
                return nil
            }
            dataArray = try NSJSONSerialization.JSONObjectWithData(fileData, options: .AllowFragments) as! [[String: String]]
            return dataArray
        } catch {
            return nil
        }
    }
    
}
