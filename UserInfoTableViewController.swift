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
    var phonebooksectionkeys = [String]()
    var sectionedphonebookuserkeys = [String:[String]]()
    var listitems = [Int:[Int]]()
    
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
        return phonebooksectionkeys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = sectionedphonebookuserkeys[phonebooksectionkeys[section]] {
            return sections.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return phonebooksectionkeys[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "UserEntryTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserEntryTableViewCell else {
            fatalError("The dequeued cell is not an instance of UserEntryTableViewCell")
        }
        
        /*
        if (indexPath.section == 0 && indexPath.row == 0) {
            listitems.removeAll()
        }*/
        
        // dictionary collection
        var names = sectionedphonebookuserkeys[phonebooksectionkeys[indexPath.section]]
        guard var name = names?[indexPath.row] else {
            fatalError("Could not extract name!")
        }
        
        //let user = phonebookuserkeys[indexPath.row]
        var tagidx = Int()
        if let allRecords = recordAccessorDelegate?.getAllRecords() {
            tagidx = calcItemIndex(section: indexPath.section, row: indexPath.row)
            cell.nameLabel.text = name
            cell.phonenumberLabel.text = allRecords[name]?[0]
            cell.addressLabel.text = allRecords[name]?[1]
            cell.editButton.tag = tagidx
            cell.deleteButton.tag = tagidx
            listitems[tagidx] = [indexPath.section, indexPath.row]
        }
        
        // update the label height
        cell.addressLabel.lineBreakMode = .byWordWrapping
        cell.addressLabel.numberOfLines = 0
        
        // add an image and make it round
        guard let firstcharinname = name.characters.first else {
            fatalError("Cannot extract first character!")
        }
        
        cell.userImageView.image = letterIconImage(drawText: String(firstcharinname) as NSString, atSize: cell.userImageView.frame.size)
        
        // change button colors
        cell.editButton.setTitleColor(UIColor(cgColor:UIColor.orange.cgColor), for:UIControlState.normal)
        cell.deleteButton.setTitleColor(UIColor(cgColor:UIColor.orange.cgColor), for:UIControlState.normal)
        return cell
    }
    
    //MARK: Private Methods
    private func loadUsers() {
        var gettinguserkeys = [String]()
        var gettingsectionkeys = [String]()
        
        guard let userkeys = recordAccessorDelegate?.getAllRecords().keys else {
            fatalError("Could not obtain user keys!")
        }
        
        // iterate collection
        for userkey in userkeys {
            gettinguserkeys.append(userkey)
        }
        
        phonebookuserkeys.removeAll()
        phonebookuserkeys.append(contentsOf:gettinguserkeys.sorted())
        
        sectionedphonebookuserkeys.removeAll()
        for name in phonebookuserkeys {
            guard let key = name.characters.first else {
                fatalError("Error!")
            }
            
            // first letter of the name is the key e
            if var arrayForLetter = sectionedphonebookuserkeys[String(key)] {
                arrayForLetter.append(name)
                sectionedphonebookuserkeys.updateValue(arrayForLetter, forKey: String(key))
            } else {
                sectionedphonebookuserkeys.updateValue([name], forKey: String(key))
            }
        }
        
        for sectionkey in sectionedphonebookuserkeys.keys {
            gettingsectionkeys.append(sectionkey)
        }
        phonebooksectionkeys.removeAll()
        phonebooksectionkeys.append(contentsOf:gettingsectionkeys.sorted())
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
    
    func calcItemIndex(section: Int, row: Int) -> Int {
        var index = 0
        for idx in 1...section+1 {
            if let sections = sectionedphonebookuserkeys[phonebooksectionkeys[idx-1]] {
                if (idx-1) == section {
                    return index + row
                }
                else {
                    index += sections.count
                }
            }
        }
        return 0
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
        if let editVC = self.storyboard?.instantiateViewController(withIdentifier:"editRecord") as? EditRecordViewController {
            if var allRecords = (recordAccessorDelegate?.getAllRecords()) {
                guard let pairitem = listitems[sender.tag] else {
                    fatalError("Cannot extract pairitem")
                }
                var names = sectionedphonebookuserkeys[phonebooksectionkeys[pairitem[0]]]
                guard let name = names?[pairitem[1]] else {
                    fatalError("Could not extract name!")
                }
                //let name = phonebookuserkeys[sender.tag]
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
            guard let pairitem = listitems[sender.tag] else {
                fatalError("Cannot extract pairitem")
            }
            var names = sectionedphonebookuserkeys[phonebooksectionkeys[pairitem[0]]]
            guard let name = names?[pairitem[1]] else {
                fatalError("Could not extract name!")
            }
            allRecords.removeValue(forKey: name)
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
