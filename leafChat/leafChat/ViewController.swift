//
//  ViewController.swift
//  leafChat
//
//  Created by Akihiro Nakano on 2024/01/01.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let uid = AuthHelper().uid()
        if uid == "" {
            performSegue(withIdentifier: "login", sender: nil)
        } else {
            print(uid)
            //チャットリストを表示する処理
        }
    }

    @IBAction func onLogOut(_ sender: Any) {
        AuthHelper().signout()
    }
    
}

