//
//  ViewController.swift
//  SimpleAddressBook
//
//  Created by Cleofas Villarin on 3/8/17.
//  Copyright © 2017 Cleofas Villarin. All rights reserved.
//

import UIKit

protocol RecordAccessorDelegate: class {
    func getAllRecords() -> [String:[String]]
    func setAllRecords(newRecords: [String:[String]])
}

class ViewController: UIViewController, RecordAccessorDelegate {
    // Constant
    let MAX_ITEM_COUNT = 10
    let BUTTON_BORDERCOLOR = UIColor.orange.cgColor
    let BUTTON_BORDERTHICKNESS:CGFloat = 1.0
    let BUTTON_BORDERCORNERRAD:CGFloat = 7.0
    
    // User data
    var phonebookusers = [String:[String]]()
    
    //MARK: Properties
    @IBOutlet weak var viewRecordsButton: UIButton!
    @IBOutlet weak var addRecordButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init UI
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named:"pointing")
        self.view.insertSubview(backgroundImage, at:0)
        
        // update
        updateButtonsForMain(button:viewRecordsButton)
        updateButtonsForMain(button:addRecordButton)
        updateButtonsForMain(button:exitButton)
        
        // init dummy data
        for idx in 1...(MAX_ITEM_COUNT - 1) {
            phonebookusers["User\(idx)"] = ["0123","the quick brown fox jumps over the lazy dog."]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private functions
    func updateButtonsForMain(button: UIButton) {
        // add blur effect
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.prominent))
        blurEffectView.frame = button.bounds
        blurEffectView.layer.cornerRadius = BUTTON_BORDERCORNERRAD
        blurEffectView.clipsToBounds = true
        blurEffectView.isUserInteractionEnabled = false
        
        // change bordercolor
        button.insertSubview(blurEffectView, at:0)
        button.layer.cornerRadius = BUTTON_BORDERCORNERRAD
        button.layer.borderWidth = BUTTON_BORDERTHICKNESS
        button.layer.borderColor = BUTTON_BORDERCOLOR
        button.setTitleColor(UIColor(cgColor:UIColor.orange.cgColor), for:UIControlState.normal)
    }
    
    //MARK: Actions
    @IBAction func viewAllRecords(_ sender: UIButton) {
        
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "listRecords") as! UserInfoTableViewController
        VC1.recordAccessorDelegate = self
        self.navigationController!.pushViewController(VC1, animated:true)
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
    func getAllRecords() -> [String:[String]] {
        return phonebookusers
    }
    func setAllRecords(newRecords: [String:[String]]) {
        phonebookusers = newRecords
    }
}

