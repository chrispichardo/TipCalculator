//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by christian pichardo on 9/21/15.
//  Copyright © 2015 christian pichardo. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tipDefaultControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //reading the default percentage
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultPercentage = defaults.integerForKey("defaultPercentage")
        //setting the segmented control to default
        tipDefaultControl.selectedSegmentIndex = defaultPercentage
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func defaultPercentageChanged(sender: AnyObject) {
       //setting the default percentage
        let defaults = NSUserDefaults.standardUserDefaults()
          defaults.setInteger(tipDefaultControl.selectedSegmentIndex, forKey: "defaultPercentage")
        defaults.synchronize()
        
    }


}
