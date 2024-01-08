//
//  AIChatViewController.swift
//  leafChat
//
//  Created by Akihiro Nakano on 2024/01/06.
//

import UIKit
import KarteCore

class AIChatViewController: UIViewController {

    @IBOutlet weak var leafChatIcon: UIImageView!
    
    var animateMoveUpFlug: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        moveAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Tracker.view("chat_ai", title: "AIチャット")
//        print("KARTE_chat_ai")
    }
    
    func moveAnimation() {
        var animator: UIViewPropertyAnimator
        if animateMoveUpFlug {
            animator = UIViewPropertyAnimator(duration: 1.0, curve: .linear, animations: {
               self.leafChatIcon.center.y -= 50
           })
        } else {
            animator = UIViewPropertyAnimator(duration: 1.0, curve: .linear, animations: {
                self.leafChatIcon.center.y += 50
            })
        }
        animator.startAnimation()
        //完了時に再帰呼び出しを行う
        animator.addCompletion{_ in
            self.animateMoveUpFlug.toggle()
            self.moveAnimation()
        }
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
