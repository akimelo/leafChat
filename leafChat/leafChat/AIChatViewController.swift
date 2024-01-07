//
//  AIChatViewController.swift
//  leafChat
//
//  Created by Akihiro Nakano on 2024/01/06.
//

import UIKit
import KarteCore

class AIChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Tracker.view("chat_ai", title: "AIチャット")
//        print("KARTE_chat_ai")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
