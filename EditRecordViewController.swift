//
//  EditRecordViewController.swift
//  SimpleAddressBook
//
//  Created by Cleofas Villarin on 3/9/17.
//  Copyright © 2017 Cleofas Villarin. All rights reserved.
//

import UIKit

class EditRecordViewController: UIViewController, UITextFieldDelegate {
    
    // Main View Controller instance
    var currentusername:String!
    var currentphonenumber:String!
    var currentuseraddress:String!
    
    weak var recordAccessorDelegate:RecordAccessorDelegate?
    weak var editRecordDelegate:EditRecordDelegate?

    //MARK: Properties
    @IBOutlet weak var nameUser: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var addressUser: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameUser.delegate = self
        nameUser.text = currentusername
        phoneNumber.delegate = self
        phoneNumber.text = currentphonenumber
        addressUser.delegate = self
        addressUser.text = currentuseraddress
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        // value retrieved at button click
    }
    
    // MARK: Actions
    @IBAction func editRecord(_ sender: UIButton) {
        let newusername = nameUser.text
        let newphonenumber = phoneNumber.text
        let newuseraddress = addressUser.text
        
        guard let username = nameUser.text, !username.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Name is empty!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let phonenumber = phoneNumber.text, !phonenumber.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Phone number is empty!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let useraddress = addressUser.text, !useraddress.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Address is empty!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if var allRecords = recordAccessorDelegate?.getAllRecords() {
            if (allRecords[newusername!] != nil) && (currentusername != newusername) {
                let alert = UIAlertController(title: "Error", message: "\"" + newusername! + "\" is already in the record!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                
                // apply changes and dismiss
                allRecords[newusername!] = [newphonenumber!,newuseraddress!]
                if currentusername != newusername {
                    allRecords[currentusername] = nil
                }
                
                recordAccessorDelegate?.setAllRecords(newRecords: allRecords)
                editRecordDelegate?.updateTable()
                
                self.presentingViewController!.dismiss(animated:true, completion:nil)
            }
        }
    }
    @IBAction func cancelRecord(_ sender: UIButton) {
        
        //dismiss
        self.dismiss(animated: true, completion:nil)
        //        self.presentingViewController?.dismiss(animated:true, completion:nil)
    }
    
}
