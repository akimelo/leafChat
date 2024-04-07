//
//  AIChatViewController.swift
//  leafChat
//
//  Created by Akihiro Nakano on 2024/01/06.
//

import UIKit
import KarteCore
import KarteVariables

class AIChatViewController: UIViewController {

    @IBOutlet weak var leafChatIcon: UIImageView!
    
    var animateMoveUpFlug: Bool = false
    
    override func loadView() {
        super.loadView()
        let uiview = nativebrik
            .experiment
            .embeddingUIView("TEST_2")
        uiview.frame = CGRect(x: 60, y: 480, width: UIScreen.main.bounds.width - 120, height: 70)
        self.view.addSubview(uiview)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        moveAnimation()
        
        let variable_remote_config_test = Variables.variable(forKey: "app_top_krt_image_url")
        let url_string = variable_remote_config_test.string(default: "app_remote_config")
        
        // UIImageViewインスタンスの作成
        let bannerImageView = UIImageView()
        bannerImageView.contentMode = .scaleAspectFit // 画像のアスペクト比を保ちつつfitさせる
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false // Auto Layoutを使用するためfalseに設定
        
        // ImageViewをViewに追加
        self.view.addSubview(bannerImageView)
        
        // Auto Layoutの制約を設定（上部・左右・高さ）
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bannerImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25) // 画面高の25%をバナーの高さに設定
        ])
        
        // 画像のURL
        if let imageUrl = URL(string: url_string) {
            // URLから画像を非同期でダウンロード
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async { // メインスレッドでUIの更新を行う
                        bannerImageView.image = UIImage(data: data)
                    }
                }
            }.resume() // URLSessionタスクを開始する
        }
        
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
