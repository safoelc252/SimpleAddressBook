//
//  ViewController.swift
//  SimpleAddressBook
//
//  Created by Cleofas Villarin on 3/8/17.
//  Copyright © 2017 Cleofas Villarin. All rights reserved.
//

import UIKit

protocol RecordAccessorDelegate: class {
    func getAllRecords() -> [String:String]
    func setAllRecords(newRecords: [String:String]) 
}

class ViewController: UIViewController, RecordAccessorDelegate {
    // Constant
    let MAX_ITEM_COUNT = 10
    
    // User data
    var phonebookusers = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for idx in 1...(MAX_ITEM_COUNT - 1) {
            phonebookusers["User\(idx)"] = "0123"
        }
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
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "listRecords") as! UserInfoTableViewController
        VC1.recordAccessorDelegate = self
        self.navigationController!.pushViewController(VC1, animated:true)
        
        /* // METHOD3: creates a new navigation controller for the new view controller and present it modally, back button is not handled with this method
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier:"listRecords") as! UITableViewController
        let navController = UINavigationController(: VC1)
        self.present(navController, animated:true, completion:nil)
        */
    }
    @IBAction func addRecord(_ sender: UIButton) {
        
        // present the add screen modally
        if (phonebookusers.count < MAX_ITEM_COUNT) {
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier:"addRecord") as! AddRecordViewController
            VC1.recordAccessorDelegate = self
            self.present(VC1, animated:true, completion:nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Record is full! Only 10 items are allowed.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func exitNow(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Alert!", message: "Are you sure you want to exit?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in exit(0)}))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Delegates
    func getAllRecords() -> [String:String] {
        return phonebookusers
    }
    func setAllRecords(newRecords: [String:String]) {
        phonebookusers = newRecords
    }
}

