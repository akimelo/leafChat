//
//  BannerStringView.swift
//  leafChat
//
//  Created by Akihiro Nakano on 2024/04/14.
//

import UIKit
import KarteCore
import KarteVariables

class BannerStringView: UIViewController {
    
    // タップされた際に遷移するURLを保持するプロパティ
    var destinationURL: URL?
    
    // カラーコードをUIColorに変換する関数
    func colorWithHexString(hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        var hexFormatted: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    override func loadView() {
        super.loadView()
        Variables.fetch()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    // -----[remote-config] Banner + String-----
        let variable_image_url_banner = Variables.variable(forKey: "app_top_krt_image_url")
        let image_url_string_banner = variable_image_url_banner.string(default: "url_string")
        
        let variable_label_text_banner = Variables.variable(forKey: "app_top_krt_label_text")
        let label_text_banner = variable_label_text_banner.string(default: "label_text")
        
        let variable_button_text_banner = Variables.variable(forKey: "app_top_krt_button_text")
        let button_text_banner = variable_button_text_banner.string(default: "button_text")
        
        let variable_link_url_banner = Variables.variable(forKey: "app_top_krt_link_url")
        let link_url_string_banner = variable_link_url_banner.string(default: "link_url")
        
        let variable_text_color_banner = Variables.variable(forKey: "app_top_krt_text_color")
        let text_color_banner = variable_text_color_banner.string(default: "text_color")
        
        // 遷移するURLを設定
        destinationURL = URL(string: link_url_string_banner)
        
        // UIImageViewインスタンスの作成
        let bannerImageView = UIImageView()
        bannerImageView.contentMode = .scaleAspectFit // 画像のアスペクト比を保ちつつfitさせる
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        bannerImageView.isUserInteractionEnabled = true // ユーザーのタップを有効にする
        self.view.addSubview(bannerImageView)
        
        let bannerLabel = UILabel()
        bannerLabel.text = label_text_banner
        bannerLabel.textAlignment = .center
        bannerLabel.translatesAutoresizingMaskIntoConstraints = false
        bannerLabel.font = UIFont.boldSystemFont(ofSize: 30)
        bannerLabel.textColor = colorWithHexString(hexString: text_color_banner)
        bannerImageView.addSubview(bannerLabel)
        
        // UIButtonインスタンスの作成
        let button = UIButton(type: .system)
        button.setTitle(button_text_banner, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left
        button.setTitleColor(colorWithHexString(hexString: text_color_banner), for: .normal)
        bannerImageView.addSubview(button) // UIImageView内に追加
        
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
            
            // Labelの制約
            bannerLabel.centerXAnchor.constraint(equalTo: bannerImageView.centerXAnchor),
            bannerLabel.centerYAnchor.constraint(equalTo: bannerImageView.centerYAnchor),
            
            // Buttonの制約
            button.leadingAnchor.constraint(equalTo: bannerImageView.leadingAnchor, constant: 20), // バナーの左から20ポイントの位置
            button.bottomAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: -50), // バナーの下から10ポイントの位置
            button.heightAnchor.constraint(equalToConstant: 44) // 高さ44ポイント
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
