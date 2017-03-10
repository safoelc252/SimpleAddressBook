//
//  ViewController.swift
//  SimpleAddressBook
//
//  Created by Cleofas Villarin on 3/8/17.
//  Copyright © 2017 Cleofas Villarin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // User data
    var phonebookusers = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for idx in 1...49 {
            phonebookusers["User\(idx)"] = "0123"
        }
        //phonebookusers["Default"] = "0123"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func viewAllRecords(_ sender: UIButton) {
        
        // DEVNOTE: The following three methods are different ways of presenting a view controller
        
        /* // METHOD1: presents the new view controller modally, without navigation
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier:"listRecords") as! UITableViewController
        self.present(controller, animated:true, completion:nil)
        */
        
        // METHOD2: pushes the new view controller to the navigation stack of the existing navigation controller, back button is handled
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "listRecords") as! UITableViewController
        (VC1 as! UserInfoTableViewController).mainViewControllerInstance = self
        self.navigationController!.pushViewController(VC1, animated:true)
        
        /* // METHOD3: creates a new navigation controller for the new view controller and present it modally, back button is not handled with this method
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier:"listRecords") as! UITableViewController
        let navController = UINavigationController(rootViewController: VC1)
        self.present(navController, animated:true, completion:nil)
        */
    }
    @IBAction func addRecord(_ sender: UIButton) {
        
        // present the add screen modally
        if (phonebookusers.count < 50) {
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier:"addRecord")
            (VC1 as! AddRecordViewController).mainViewControllerInstance = self
            self.present(VC1, animated:true, completion:nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Record capacity is only 50 and is now full!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

