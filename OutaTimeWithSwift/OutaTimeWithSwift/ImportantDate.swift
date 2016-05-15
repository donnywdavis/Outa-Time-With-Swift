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
    
    init(title: String?, date: NSDate?) {
        self.title = title
        self.date = date
    }
    
    init?(importantDateDictionary: [String: String]) {
        guard let title = importantDateDictionary["title"], let date = importantDateDictionary["date"] else {
            return nil
        }
        self.title = title
        self.date = Date.convertDateFromString(date, format: "MMddyyyy")
    }
    
    class func convertDateFromString(date: String, format: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        guard let convertedDate = dateFormatter.dateFromString(date) else {
            return nil
        }
        return convertedDate
    }
    
    class func convertDateToString(date: NSDate, style: NSDateFormatterStyle) -> String? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.stringFromDate(date)
    }
    
    class func loadImportantDates() -> [Date]? {
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
            datesArray.append(Date(importantDateDictionary: importantDate)!)
        }
        
        return datesArray
    }
    
}
