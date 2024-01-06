//
//  ChatView.swift
//  leafChat
//
//  Created by Akihiro Nakano on 2024/01/05.
//

import UIKit

class ChatView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let database = DatabaseHelper()
    var roomData:ChatRoom!
    var chatData:[ChatText] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        database.getUserName(userID: roomData.userID, result: {
            name in
            self.navigationItem.title = name
        })
        database.chatDataListener(roomID: roomData.roomID, result: {
            result in
            self.chatData = result
            self.messageUpdated()
        })
    }
    
    func messageUpdated(){
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell
        let data = chatData[indexPath.row]
        if data.userID == AuthHelper().uid() {
            // This is my text
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")!
        } else {
            // This is friends' text
            cell = tableView.dequeueReusableCell(withIdentifier: "cell1")!
        }
        let imageView = cell.viewWithTag(2) as! UIImageView
        imageView.layer.cornerRadius = imageView.frame.height*0.5
        imageView.clipsToBounds = true
        database.getImage(userID: data.userID, imageView: imageView)
        let label = cell.viewWithTag(1) as! UILabel
        label.text = data.text
        label.layer.cornerRadius = imageView.frame.height*0.5
        label.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}
