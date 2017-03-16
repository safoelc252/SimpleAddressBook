//
//  UserInfoTableViewController.swift
//  SimpleAddressBook
//
//  Created by Cleofas Villarin on 3/8/17.
//  Copyright © 2017 Cleofas Villarin. All rights reserved.
//

import UIKit
import CoreGraphics // villarinc, added for dynamic rendering of text on images

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
        
        // make the cell height dynamic
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
        
        // add an image and make it round
        
        guard let firstcharinname = user.characters.first else {
            fatalError("Cannot extract first character!")
        }
        
        cell.userImageView.image = letterIconImage(drawText: String(firstcharinname) as NSString, atSize: cell.userImageView.frame.size)
        
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
    
    //MARK: Public methods
    func letterIconImage(drawText text: NSString, atSize imgsize:CGSize) -> UIImage {
        
        // prepare the font
        let textColor = UIColor.white
        guard let textFont = UIFont(name: "Helvetica Bold", size: 40) else {
            fatalError("Text font was not created!")
        }
        
        let scale = UIScreen.main.scale
        let apricotOrange = UIColor(red:CGFloat(251)/255.0,
                                    green:CGFloat(206)/255.0,
                                    blue:CGFloat(177)/255,
                                    alpha:CGFloat(1.0))
        let image = getRoundBkndImage(color: apricotOrange, size: imgsize, diameter: Int(imgsize.width - 20))
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        
        // draw the image first
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        // then draw centered text
        let stringsize = text.size(attributes: textFontAttributes)
        let rect = CGRect(origin: CGPoint(x: (image.size.width - stringsize.width)/2,
                                          y: (image.size.height - stringsize.height)/2),
                          size: CGSize(width: stringsize.width,
                                       height: stringsize.height))
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func getRoundBkndImage(color: UIColor, size: CGSize, diameter: Int) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.saveGState()
        
            let box = CGSize(width:diameter, height:diameter)
            let point = CGPoint(x:(Int(size.width) - diameter)/2, y:(Int(size.height) - diameter)/2)
            let circle = CGRect(origin:point, size: box)
            ctx.setFillColor(color.cgColor)
            ctx.fillEllipse(in: circle)
            ctx.restoreGState()
        }
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError("Image not generated!")
        }
        UIGraphicsEndImageContext()
        return image
    }
    
    //MARK: Appendix functions
    func getRandColor() -> UIColor {
        
        return UIColor(red:CGFloat(randomInt(min: 0, max: 255))/255.0,
                       green:CGFloat(randomInt(min: 0, max: 255))/255.0,
                       blue:CGFloat(randomInt(min: 0, max: 255))/255,
                       alpha:CGFloat(1.0))
    }
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
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
