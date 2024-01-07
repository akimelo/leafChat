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
        let env = try! LoadEnv()
        print(env.value("API_KEY")!)        
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.overrideUserInterfaceStyle = .dark
        
        let uid = AuthHelper().uid()
        let database = DatabaseHelper()
        
        if uid == "" {
            performSegue(withIdentifier: "login", sender: nil)
        } else {
            var iconimageurl = ""
            let email = AuthHelper().email()
            
            database.getImageURL(userID: uid) { imageUrl, error in
                if let error = error {
                    // エラー処理
                    print("Error getting image URL: \(error)")
                } else if let imageUrl = imageUrl {
                    // imageUrlを使用した処理
                    iconimageurl = imageUrl
                    print("Download URL: \(imageUrl)")
                    Tracker.track("attribute", values: [
                        "icon_img": iconimageurl,
                        "email": email
                    ])
                }
            }
            
            database.getUserName(userID: uid, result: {
                result in
                if result == ""{
                    print("Can't find user_id")
                } else {
                    print("imageurl: " + iconimageurl)
                    print("KARTE login")
                    Tracker.identify(
                        uid,
                        ["name": result]
                    )
                }
            })
            print(uid)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Tracker.view("menu", title: "メニュー")
//        print("KARTE_menu")
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        AuthHelper().signout()
        performSegue(withIdentifier: "login", sender: nil)
    }

}
