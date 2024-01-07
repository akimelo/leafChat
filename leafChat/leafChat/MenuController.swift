//
//  MenuController.swift
//  leafChat
//
//  Created by Akihiro Nakano on 2024/01/06.
//

import UIKit
import KarteCore

class MenuController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.overrideUserInterfaceStyle = .dark
        
        let uid = AuthHelper().uid()
        if uid == "" {
            performSegue(withIdentifier: "login", sender: nil)
        } else {
            print(uid)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Tracker.view("", title: "")
//        print("KARTE_")
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        AuthHelper().signout()
        performSegue(withIdentifier: "login", sender: nil)
    }

}
