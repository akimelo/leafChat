//
//  MenuController.swift
//  leafChat
//
//  Created by Akihiro Nakano on 2024/01/06.
//

import UIKit
import KarteCore
import Nativebrik

let env = try! LoadEnv()
let nativebrik = {
    return NativebrikClient(projectId: env.value("PROJECT_ID_NATIVEBRIK")!)
}()

class ViewController: UIViewController {
    
//    private let nbView = NativeBrikView()
    @IBOutlet weak var iconVIew: UIImageView!
    @IBOutlet weak var iconName: UILabel!
    
    override func loadView() {
        super.loadView()
        let uiview = nativebrik
            .experiment
            .embeddingUIView("TEST_1")
        uiview.frame = CGRect(x: 20, y: 635, width: UIScreen.main.bounds.width - 40, height: 65)
        self.view.addSubview(uiview)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add nativebrik.overlay to the top.
        iconVIew.layer.cornerRadius = iconVIew.frame.size.width * 0.5
        
        let overlay = nativebrik.overlayViewController()
        self.addChild(overlay)
        self.view.addSubview(overlay.view)

        // Do any additional setup after loading the view.        
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
            
            database.getImage(userID: uid, imageView: iconVIew)
            database.getUserName(userID: uid, result: {
                name in
                self.iconName.text = name
            })
            
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
