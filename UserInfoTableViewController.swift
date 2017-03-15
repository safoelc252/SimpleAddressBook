//
//  UserInfoTableViewController.swift
//  SimpleAddressBook
//
//  Created by Cleofas Villarin on 3/8/17.
//  Copyright © 2017 Cleofas Villarin. All rights reserved.
//

import UIKit

protocol EditRecordDelegate: class {
    func updateTable()
}

class UserInfoTableViewController: UITableViewController, EditRecordDelegate {
    
    //MARK: Properties
    weak var recordAccessorDelegate: RecordAccessorDelegate?
    var phonebookuserkeys = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUsers()
        
        // update navigation title
        self.navigationItem.title = "Records List"
        
        
        self.tableView.estimatedRowHeight = 89
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let allRecords = recordAccessorDelegate?.getAllRecords() {
            return allRecords.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "UserEntryTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserEntryTableViewCell else {
            fatalError("The dequeued cell is not an instance of UserEntryTableViewCell")
        }
        
        // dictionary collection
        let user = phonebookuserkeys[indexPath.row]
        if let allRecords = recordAccessorDelegate?.getAllRecords() {
            cell.nameLabel.text = user
            cell.phonenumberLabel.text = allRecords[user]?[0]
            cell.addressLabel.text = allRecords[user]?[1]
            cell.editButton.tag = indexPath.row
            cell.deleteButton.tag = indexPath.row
        }
        
        // update the label height
        cell.addressLabel.lineBreakMode = .byWordWrapping
        cell.addressLabel.numberOfLines = 0
        return cell
    }
    
    //MARK: Private Methods
    private func loadUsers() {
        phonebookuserkeys.removeAll()
        // iterate collection
        for userkey in (recordAccessorDelegate?.getAllRecords().keys)! {
            phonebookuserkeys.append(userkey)
        }
    }
    
    //MARK: Actions
    @IBAction func editCurrent(_ sender: UIButton) {
        // present the edit screen modally
        if let editVC = self.storyboard!.instantiateViewController(withIdentifier:"editRecord") as? EditRecordViewController {
            if var allRecords = (recordAccessorDelegate?.getAllRecords()) {
                let name = phonebookuserkeys[sender.tag]
                editVC.currentusername = name
                editVC.currentphonenumber = allRecords[name]?[0]
                editVC.currentuseraddress = allRecords[name]?[1]
                editVC.recordAccessorDelegate = self.recordAccessorDelegate
                editVC.editRecordDelegate = self
                self.present(editVC, animated:true, completion:nil)
            }
        }
    }
    
    @IBAction func deleteCurrent(_ sender: UIButton) {
        if var allRecords:[String:[String]] = (recordAccessorDelegate?.getAllRecords()) {
            allRecords.removeValue(forKey: phonebookuserkeys[sender.tag])
            recordAccessorDelegate?.setAllRecords(newRecords: allRecords)
        }
        loadUsers()
        self.tableView.reloadData()
    }
    
    //MARK: Delegate
    func updateTable() {
        loadUsers()
        self.tableView.reloadData()
    }
}
