//
//  AddTwoViewController.swift
//  Sunflower
//
//  Created by Arash K. on 19/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class AddTwoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onNextTapped(sender: AnyObject) {
        if userHasEnoughCredit()
        {
            self.performSegueWithIdentifier("fromaddtwotoaddthree", sender: nil)
        } else {
            self.performSegueWithIdentifier("fromaddtwotobuycredit", sender: nil)
        }
    }
    
    func userHasEnoughCredit() -> Bool{
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
