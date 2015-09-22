//
//  ViewController.swift
//  TipCalculator
//
//  Created by christian pichardo on 9/21/15.
//  Copyright © 2015 christian pichardo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billAmountField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var splitBillView: UIView!
    @IBOutlet weak var split2xLabel: UILabel!
    @IBOutlet weak var split3xLabel: UILabel!
    @IBOutlet weak var split4xLabel: UILabel!
    var total = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Notification for keyboard show
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        
        //Notification for entering in background 
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didEnterBackground:"), name:UIApplicationDidEnterBackgroundNotification, object: nil)
        
        //retrieve bill amount
        let defaults = NSUserDefaults.standardUserDefaults()
        let bAmount = defaults.stringForKey("billAmount")
        let closingTime = defaults.objectForKey("closeTime")
       
        //In case the app was closed and not running on the background, lets keep track of the closed time using the nsuserdefault to clear the amount field after the 10mins
        if(closingTime != nil){
            let now = NSDate()
            let distanceBetweenDates = now.timeIntervalSinceDate(closingTime as! NSDate)
            let minutesElapsed = distanceBetweenDates / 60;
                //if the app was closed in less than 10mins set the amount to the stored amount
            if(minutesElapsed<10 && bAmount != nil){
                billAmountField.text = bAmount!
            }else{
                //else clean the data
                clearData();
            }
        }
       
        //Show keyboard on load
        billAmountField.becomeFirstResponder();
        //Initialize labels
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
       
        //making navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
      
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        //Initialize the segmented control with default percentage
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultPercentage = defaults.integerForKey("defaultPercentage")
        if(tipControl.selectedSegmentIndex != defaultPercentage){
            tipControl.selectedSegmentIndex = defaultPercentage
            billEditingChanged(tipControl)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func billEditingChanged(sender: AnyObject) {
        
        //Percentages
        var percentages = [0.18,0.20,0.22]
        let percentage = percentages[tipControl.selectedSegmentIndex]
        //calculate total
        let amount = (billAmountField.text! as NSString).doubleValue
        let tip = amount*percentage
        total = amount+tip
        //update label for tips and total
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        tipLabel.text = formatter.stringFromNumber(tip)
        totalLabel.text = formatter.stringFromNumber(total)
        updateSplitBillLabels()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(billAmountField.text, forKey: "billAmount")
    }

    @IBAction func showSplitBillView(sender: AnyObject) {
        //if split view is already showing then hide and display keyboard
        if(self.splitBillView.alpha == 1.0){
            billAmountField.becomeFirstResponder()
        }else{
            //else update split labels
            updateSplitBillLabels();
            //close keyboard
            view.endEditing(true)
            //animate split view fading in
            UIView.animateWithDuration(1.5, animations: {
                self.splitBillView.alpha = 1.0
            })
        }
        
    }
    //when showing keyboard hide the split bill view
    func keyboardWillShow(sender: NSNotification) {
        self.splitBillView.alpha = 0
    }
    //update split labels
    func updateSplitBillLabels(){
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        let split2x =  formatter.stringFromNumber(total/2)!
        let split3x =  formatter.stringFromNumber(total/3)!
        let split4x =  formatter.stringFromNumber(total/4)!
        
        split2xLabel.text = split2x
        split3xLabel.text = split3x
        split4xLabel.text = split4x
        
    }
    //when the app is entering background if 10mins passed clear the data
    func didEnterBackground(sender: NSNotification) {
         NSTimer.scheduledTimerWithTimeInterval(600, target: self, selector: "clearData", userInfo: nil, repeats: false)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(NSDate(), forKey: "closeTime")

    }
    
    //function to clear the stored amount
    func clearData(){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("billAmount")
        defaults.synchronize()
        billAmountField.text = nil
        billEditingChanged(billAmountField)
        
    }

 
}

