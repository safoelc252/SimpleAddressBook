//
//  UserInfoTableViewController.swift
//  SimpleAddressBook
//
//  Created by Cleofas Villarin on 3/8/17.
//  Copyright © 2017 Cleofas Villarin. All rights reserved.
//

import UIKit

protocol EditRecordDelegate: class{
    func updateRecordTable(oldusername:String, newusername:String, newphonenumber:String)
    func getValue(key:String) -> String
}

class UserInfoTableViewController: UITableViewController, EditRecordDelegate {
    
    //MARK: Properties
    var mainViewControllerInstance:ViewController!
    var phonebookuserkeys = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleUsers()
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
        return mainViewControllerInstance!.phonebookusers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "UserEntryTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserEntryTableViewCell else {
            fatalError("The dequeued cell is not an instance of UserEntryTableViewCell")
        }
        
        // dictionary collection
        let user = phonebookuserkeys[indexPath.row]
        
        cell.nameLabel.text = user
        cell.phonenumberLabel.text = mainViewControllerInstance!.phonebookusers[user]
        cell.editButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Private Methods
    private func loadSampleUsers() {
        phonebookuserkeys.removeAll()
        // iterate collection
        for userkey in mainViewControllerInstance.phonebookusers.keys {
            phonebookuserkeys.append(userkey)
        }
    }
    
    //MARK: Actions
    @IBAction func editCurrent(_ sender: UIButton) {
        // present the edit screen modally
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier:"editRecord")
        weak var editVC = (VC1 as! EditRecordViewController)
        editVC!.currentusername = phonebookuserkeys[sender.tag]
        editVC!.currentphonenumber = mainViewControllerInstance.phonebookusers[phonebookuserkeys[sender.tag]]!
        editVC!.editRecordDelegate = self
        self.present(VC1, animated:true, completion:nil)
    }
    @IBAction func deleteCurrent(_ sender: UIButton) {
        mainViewControllerInstance.phonebookusers[phonebookuserkeys[sender.tag]] = nil
        loadSampleUsers()
        self.tableView.reloadData()
    }
    
    //MARK: Delegate
    func updateRecordTable(oldusername:String, newusername:String, newphonenumber:String) {
        // Apply changes to current data model
        mainViewControllerInstance.phonebookusers[newusername] = newphonenumber
        if oldusername != newusername {
            mainViewControllerInstance.phonebookusers[oldusername] = nil
        }
        for userkey in mainViewControllerInstance.phonebookusers.keys {
            phonebookuserkeys.append(userkey)
        }
        
        loadSampleUsers()
        self.tableView.reloadData()
    }
    
    func getValue(key:String) -> String {
        if (mainViewControllerInstance.phonebookusers[key] != nil) {
            return mainViewControllerInstance.phonebookusers[key]!
        } else {
            return "none"
        }
    }
}
