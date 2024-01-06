//
//  MenuController.swift
//  leafChat
//
//  Created by Akihiro Nakano on 2024/01/06.
//

import UIKit

class MenuController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        AuthHelper().signout()
        performSegue(withIdentifier: "login", sender: nil)
    }

}
