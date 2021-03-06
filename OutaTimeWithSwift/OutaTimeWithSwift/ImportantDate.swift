//
//  ImportantDate.swift
//  OutaTimeWithSwift
//
//  Created by Donny Davis on 5/15/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

extension NSDate {
    func convertToStringWithFormat(dateFormatter: NSDateFormatter, format: String) -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
    
    func convertToStringWithStyle(dateFormatter: NSDateFormatter, style:NSDateFormatterStyle) -> String {
        dateFormatter.dateStyle = style
        return dateFormatter.stringFromDate(self)
    }
}

extension String {
    func convertToDateWithFormat(dateFormatter: NSDateFormatter, format: String) -> NSDate? {
        dateFormatter.dateFormat = format
        guard let convertedDate = dateFormatter.dateFromString(self) else {
            return nil
        }
        return convertedDate
    }
}

class Date: NSObject {
    let title: String?
    let date: NSDate?
    
    static let dateFormatter = NSDateFormatter()
    
    
    //
    // MARK: Initializers
    //
    
    init?(title: String?, date: NSDate?) {
        guard let title = title, let date = date else {
            return nil
        }
        self.title = title
        self.date = date
    }
    
    init?(datesDictionary: [String: String]) {
        guard let title = datesDictionary["title"], let date = datesDictionary["date"] else {
            return nil
        }
        self.title = title
        self.date = date.convertToDateWithFormat(Date.dateFormatter, format: "MMddyyyy")
    }
    
    
    //
    // MARK: Class methods
    //
    
    //
    // Unpack a Date object back into a dictionary
    //
    class func convertDateObjectToDictionary(dateObject: Date) -> [String: String] {
        var newDictionary = [String: String]()
        newDictionary["title"] = dateObject.title
        if let date = dateObject.date?.convertToStringWithFormat(dateFormatter, format: "MMddyyyy") {
            newDictionary["date"] = date
        }
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
        guard var historyArray = currentHistory() else {
            return
        }
        
        // Convert the date to a dictionary
        let newDate = Date.convertDateObjectToDictionary(historyDate)
        
        for date in historyArray {
            if date == newDate {
                return
            }
        }
        
        // Add our new date to the current array
        historyArray.append(Date.convertDateObjectToDictionary(historyDate))
        
        writeHistoryData(historyArray)

    }
    
    //
    // Remove date from history list
    //
    class func removeHistoryDate(index: NSIndexPath) {
        // Get our current history items
        guard var historyArray = currentHistory() else {
            return
        }
        
        // Remove the specified date
        historyArray.removeAtIndex(index.row)
        
        writeHistoryData(historyArray)
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
    
    //
    // Write history date to file
    //
    private class func writeHistoryData(historyArray: [[String: String]]) {
        // Check that we have a file path
        guard let filePath = getHistoryPath() else {
            return
        }
        
        // Create an output stream to write to
        let outputStream = NSOutputStream(toFileAtPath: filePath, append: false)
        
        // Open up the output stream for writing to
        outputStream?.open()
        
        // Write the new date to the file
        NSJSONSerialization.writeJSONObject(historyArray, toStream: outputStream!, options: .PrettyPrinted, error: nil)
        
        // Close the output stream
        outputStream?.close()
    }
    
}
