//
//  ViewController.swift
//  leafChat
//
//  Created by Akihiro Nakano on 2024/01/01.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var dataHelper = DatabaseHelper()
    var roomList:[ChatRoom] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let uid = AuthHelper().uid()
        if uid == "" {
            performSegue(withIdentifier: "login", sender: nil)
        } else {
            print(uid)
            //チャットリストを表示する処理
            dataHelper.getMyRoomList(result: {
                result in
                print(result)
                self.roomList = result
                self.tableView.reloadData()
            })
        }
    }

    @IBAction func onLogOut(_ sender: Any) {
        AuthHelper().signout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection")
        print(roomList.count)
        return roomList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("heightForRowAt")
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = roomList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let imageView = cell?.viewWithTag(1) as! UIImageView
        imageView.layer.cornerRadius = imageView.frame.size.width * 0.5
        imageView.clipsToBounds = true
        print("userID:" + cellData.userID)
        dataHelper.getImage(userID: cellData.userID, imageView: imageView)
        let nameLabel = cell?.viewWithTag(2) as! UILabel
        dataHelper.getUserName(userID: cellData.userID, result: {
            name in
            nameLabel.text = name
            print("name:" + name)
        })
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "chat", sender: roomList[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chat"{
            let VC = segue.destination as! ChatView
            let data = sender as! ChatRoom
            VC.roomData = data
        }
    }
}

