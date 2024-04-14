//
//  BigCarouselView.swift
//  leafChat
//
//  Created by Akihiro Nakano on 2024/04/14.
//

import UIKit
import KarteCore
import KarteVariables

class BigCarouselView: UIViewController {
    
    override func loadView() {
        super.loadView()
        Variables.fetch()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    // -----[remote-config] Banner + String-----
        let variable_contents_carousel = Variables.variable(forKey: "account_top_contents")
        let contents_string_carousel = variable_contents_carousel.string(default: "contents")
        print(contents_string_carousel)
        
//        let keys = Variables.getAllKeys()
//        print(keys)
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
