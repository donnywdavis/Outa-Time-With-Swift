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

class DestinationViewController: UIViewController {
    
    //
    // MARK: Properties
    //
    
    @IBOutlet weak var destinationDatePicker: UIDatePicker!
    
    weak var delegate: DestinationDateSelectionDelegate?

    //
    // MARK: View Lifecycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Destination Date"

//        destinationDatePicker.performSelector(Selector("setHighlightsToday:"), withObject:UIColor.whiteColor())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.selectedDestinationDate(destinationDatePicker.date)
    }

}
