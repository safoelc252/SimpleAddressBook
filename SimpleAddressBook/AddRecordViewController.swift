//
//  AddRecordViewController.swift
//  SimpleAddressBook
//
//  Created by Cleofas Villarin on 3/9/17.
//  Copyright © 2017 Cleofas Villarin. All rights reserved.
//

import UIKit

class AddRecordViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    weak var recordAccessorDelegate:RecordAccessorDelegate?
    @IBOutlet weak var nameUser: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var addressUser: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameUser.delegate = self
        phoneNumber.delegate = self
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
    
    //MARK: Actions
    
    @IBAction func addRecord(_ sender: UIButton) {
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
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if var allRecords = recordAccessorDelegate?.getAllRecords() {
            // validate add
            if allRecords[newusername!] == nil {
                allRecords[newusername!] = [newphonenumber!,newuseraddress!]
        
                recordAccessorDelegate?.setAllRecords(newRecords: allRecords)
                // dismiss the modal view
                self.presentingViewController!.dismiss(animated:true, completion:nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "\"" + nameUser.text! + "\" is already in the record!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func cancelRecord(_ sender: UIButton) {
        
        // dismiss the modal view
        self.presentingViewController!.dismiss(animated:true, completion:nil)
    }
}
