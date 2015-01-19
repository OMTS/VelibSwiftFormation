//
//  MapViewController.swift
//  VelibFormationSwift
//
//  Created by Iman Zarrabian on 19/01/15.
//  Copyright (c) 2015 Iman Zarrabian. All rights reserved.
//

import UIKit

class MapViewController: UIViewController,UINavigationBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func gobackToList(sender : AnyObject) {
        if sender is UIButton {
            NSLog("BUTTON")
        }
        else {
            if sender is UIBarButtonItem {
                NSLog("BAR BUTTON ITEM")
            }
            else {
                NSLog("WRONG TYPE")
            }
        }
        //This is also valid I Guess (trying some optional cast)
        if let button = sender as? UIBarButtonItem {
            // object is successfully cast to type UIBarButtonItem and bound to button
            NSLog("BAR BUTTON ITEM CASTED")
        } else {
            // object could not be cast to type UIButton
            NSLog("CANNOT CAST BUTTON")
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
