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
    
    weak var editRecordDelegate:EditRecordDelegate?

    //MARK: Properties
    @IBOutlet weak var nameUser: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameUser.delegate = self
        nameUser.text = currentusername
        phoneNumber.delegate = self
        phoneNumber.text = currentphonenumber
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
        if (editRecordDelegate?.getValue(key: nameUser.text!) != "none") && (currentusername != nameUser.text) {
            let alert = UIAlertController(title: "Error", message: "\"" + nameUser.text! + "\" is already in the record!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            // apply changes and dismiss
            editRecordDelegate?.updateRecordTable(oldusername: currentusername, newusername: nameUser.text!, newphonenumber: phoneNumber.text!)
            self.presentingViewController!.dismiss(animated:true, completion:nil)
        }
    }
    @IBAction func cancelRecord(_ sender: UIButton) {
        
        //dismiss
        self.presentingViewController!.dismiss(animated:true, completion:nil)
    }
    
}
