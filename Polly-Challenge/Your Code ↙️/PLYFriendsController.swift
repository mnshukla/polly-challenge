
//
//  PLYFriendsController.swift
//  polly-challenge
//
//  Created by Vicc Alexander on 10/3/17.
//  Copyright © 2017 Polly Inc. All rights reserved.
//

import UIKit
import SnapKit

class PLYFriendsController: PLYController, UITableViewDelegate, UITableViewDataSource {
    
    
    //-----------------------------------
    // MARK: - Properties
    //-----------------------------------
    
    fileprivate var usersToAdd: [PLYUser] = []
    fileprivate var usersInContacts: [PLYUser] = []
    
    private var quickAddTableView: UITableView = UITableView()
    private var contactsTableView: UITableView = UITableView()
    
    //-----------------------------------
    // MARK: - View Lifecycle
    //-----------------------------------
    
    override func viewDidLoad() {
        
        // Super
        super.viewDidLoad()
        
        makeConstraints()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Super
        super.viewDidAppear(animated)
        
        // Refresh users
        refreshUsers()
    }
    
    override func viewDidLayoutSubviews(){
        self.quickAddTableView.frame = CGRect(x: self.quickAddTableView.frame.origin.x, y: self.quickAddTableView.frame.origin.y, width: self.quickAddTableView.frame.size.width, height: self.quickAddTableView.contentSize.height)
        self.contactsTableView.frame = CGRect(x: self.contactsTableView.frame.origin.x, y: self.contactsTableView.frame.origin.y, width: self.contactsTableView.frame.size.width, height: self.contactsTableView.contentSize.height)
        
        
        self.quickAddTableView.reloadData()
        self.contactsTableView.reloadData()
    }
    
    //-----------------------------------
    // MARK: - Setup View
    //-----------------------------------
    
    override func setupUI() {
        
        // Super
        super.setupUI()
        
//        self.quickAddTableView.frame = CGRect(x: 0, y: 73, width: cardView.frame.width-16, height: 100)
        self.quickAddTableView.tag = 0
        self.quickAddTableView.dataSource = self
        self.quickAddTableView.delegate = self
        self.quickAddTableView.register(UITableViewCell.self, forCellReuseIdentifier: "quickAddCell")
        self.quickAddTableView.layer.cornerRadius = CGFloat(12)
        self.cardView.addSubview(self.quickAddTableView)
        
//        self.contactsTableView.frame = CGRect(x: 0, y: 193, width: cardView.frame.width-16, height: 100)
        self.contactsTableView.tag = 1
        self.contactsTableView.dataSource = self
        self.contactsTableView.delegate = self
        self.contactsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "contactsCell")
        self.contactsTableView.layer.cornerRadius = CGFloat(12)
        self.cardView.addSubview(self.contactsTableView)
        
//        makeConstraints()
        
        /*
         NOTE: Instead of adding your subviews to the controller's view, make sure to add them to cardView.
         - i.e. cardView.addSubview(yourView)
         */
    }
    
    func makeConstraints()
    {
        let padding = UIEdgeInsetsMake(8, 8, 8, 8);
//
        self.quickAddTableView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(cardView.frame.width-16)
            make.height.equalTo(200)
            make.top.equalTo(self.cardView.snp.top).offset(padding.top)
            make.left.equalTo(self.cardView.snp.left).offset(padding.left)
        }
        
        self.contactsTableView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(cardView.frame.width-16)
            make.height.equalTo(200)
            make.top.equalTo(self.quickAddTableView.snp.bottom).offset(padding.top)
            make.left.equalTo(self.cardView.snp.left).offset(padding.left)
        }

        self.quickAddTableView.sizeToFit()
        self.contactsTableView.sizeToFit()
    }
    
    //-----------------------------------
    // MARK: - Refreshing Data
    //-----------------------------------
    
    fileprivate func refreshUsers() {
        
        /* NOTE: On refresh the number of users for each array may change (Simulating real world updates). Make sure to account for this.*/
        
        // Update users
        usersToAdd = PLYManager.shared.quickAdds()
        usersInContacts = PLYManager.shared.invites()
        
        // Update the view here
        self.quickAddTableView.reloadData()
        self.contactsTableView.reloadData()
        
        if usersToAdd.count == 0
        {
            self.quickAddTableView.isHidden = true
        }
        
        if usersInContacts.count == 0
        {
            self.contactsTableView.isHidden = true
        }
        
    }
    
    //-----------------------------------
    // MARK: - Table View Data Source Methods
    //-----------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "quickAddCell", for: indexPath)
            print(cell.frame.width)
            let user = usersToAdd[indexPath.row]
            cell.imageView?.image = user.avatar
            cell.textLabel?.text = String("\(user.firstName!) \(user.lastName!)")
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            let addButton = UIButton(type: UIButtonType.roundedRect)
            addButton.setTitle("+ Add", for: .normal)
            addButton.backgroundColor = .blue
            addButton.titleLabel?.textColor = .white
            addButton.titleLabel?.font = UIFont(name: "ProximaNova-Semibold", size: CGFloat(8))
            addButton.layer.cornerRadius = 12
            cell.addSubview(addButton)
            addButton.snp.makeConstraints({ (make) in
                make.width.equalTo(45)
                make.height.equalTo(35)
                make.top.equalTo(cell).offset(4)
                make.right.equalTo(cell).offset(-8)
            })
            return cell
        }
        
        // Invite
        else
        {
            var cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell", for: indexPath)
//            if cell == nil
//            {
//                cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "contactsCell")
//            }
            print("USERS TO ADD")
            for user in usersToAdd {
                print("\(user)")
            }
            print("usersincontacts")
            for user in usersInContacts {
                print("\(user)")
            }
            print("INDEXPATH: \(indexPath.row)")
            let user = usersToAdd[indexPath.row]
            cell.imageView?.image = user.avatar
            cell.textLabel?.text = String("\(user.firstName!) \(user.lastName!)")
            cell.detailTextLabel?.text = user.phoneNumber
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            let inviteButton = UIButton(type: UIButtonType.roundedRect)
            inviteButton.setTitle("+ Invite", for: .normal)
            inviteButton.backgroundColor = .white
            inviteButton.titleLabel?.textColor = .lightGray
            inviteButton.titleLabel?.font = UIFont(name: "ProximaNova-Semibold", size: CGFloat(8))
            inviteButton.layer.cornerRadius = 12
            cell.addSubview(inviteButton)
            inviteButton.snp.makeConstraints({ (make) in
                make.width.equalTo(45)
                make.height.equalTo(35)
                make.top.equalTo(cell).offset(4)
                make.right.equalTo(cell).offset(-8)
            })
            return cell
        }
    }
    
    //-----------------------------------
    // MARK: - Table View Delegate Methods
    //-----------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0
        {
            return usersToAdd.count
        }
        else
        {
            return usersInContacts.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //-----------------------------------
    // MARK: - Memory Management
    //-----------------------------------
    
    override func didReceiveMemoryWarning() {
        
        // Super
        super.didReceiveMemoryWarning()
    }

}
