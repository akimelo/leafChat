//
//  ConfigView.swift
//  leafChat
//
//  Created by Akihiro Nakano on 2024/04/09.
//

import UIKit
import KarteCore
import KarteVariables

class ConfigView: UIViewController {
    
    @IBOutlet weak var count_label: UILabel!
    
    // タップされた際に遷移するURLを保持するプロパティ
    var destinationURL: URL?
    
    override func loadView() {
        super.loadView()
        Variables.fetch()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    // -----[remote-config] count-----
        let variable_count = Variables.variable(forKey: "config_count")
        let count_string = variable_count.string(default: "count")
        
        count_label.text = count_string
        
    // -----[remote-config] Banner1-----
        let variable_image_url_banner = Variables.variable(forKey: "home_top_krt_image_url")
        let image_url_string_banner = variable_image_url_banner.string(default: "url_string")
        
        let variable_link_url_banner = Variables.variable(forKey: "home_top_krt_link_url")
        let link_url_string_banner = variable_link_url_banner.string(default: "link_url")
        
        // 遷移するURLを設定
        destinationURL = URL(string: link_url_string_banner)
        
        // UIImageViewインスタンスの作成
        let bannerImageView = UIImageView()
        bannerImageView.contentMode = .scaleAspectFit // 画像のアスペクト比を保ちつつfitさせる
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        bannerImageView.isUserInteractionEnabled = true // ユーザーのタップを有効にする
        self.view.addSubview(bannerImageView)
        
        // タップジェスチャーの追加
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bannerTapped))
        bannerImageView.addGestureRecognizer(tapGesture)
        
        // Auto Layoutの制約を設定
        NSLayoutConstraint.activate([
            // ImageViewの制約
            bannerImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bannerImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25), // 画面高の25%をバナーの高さに設定
        ])
        
        // 画像のURL
        if let imageUrl_banner = URL(string: image_url_string_banner) {
            // URLから画像を非同期でダウンロード
            URLSession.shared.dataTask(with: imageUrl_banner) { data, response, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async { // メインスレッドでUIの更新を行う
                        bannerImageView.image = UIImage(data: data)
                    }
                }
            }.resume() // URLSessionタスクを開始する
        }
    }
    
    @objc func bannerTapped() {
        // 定義したURLを開く
        if let url = destinationURL {
            UIApplication.shared.open(url)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Tracker.view("config", title: "設定値配信用ページ")
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
