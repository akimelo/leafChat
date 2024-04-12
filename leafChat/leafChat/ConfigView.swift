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
    var destinationURL1: URL?
    var destinationURL2: URL?
    
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
        
    // -----[remote-config] count-----
        let variable_count = Variables.variable(forKey: "aki_count")
        let count_string = variable_count.string(default: "count")
        
        count_label.text = count_string
        
    // -----[remote-config] Banner1-----
        let variable_image_url_banner1 = Variables.variable(forKey: "home_top_krt_image_url")
        let image_url_string_banner1 = variable_image_url_banner1.string(default: "url_string")
        
        let variable_link_url_banner1 = Variables.variable(forKey: "home_top_krt_link_url")
        let link_url_string_banner1 = variable_link_url_banner1.string(default: "link_url")
        
        // 遷移するURLを設定
        // destinationURL1 = URL(string: link_url_string_banner1)
        
        // UIImageViewインスタンスの作成
        let bannerImageView1 = UIImageView()
        bannerImageView1.contentMode = .scaleAspectFit // 画像のアスペクト比を保ちつつfitさせる
        bannerImageView1.translatesAutoresizingMaskIntoConstraints = false
        bannerImageView1.isUserInteractionEnabled = true // ユーザーのタップを有効にする
        self.view.addSubview(bannerImageView1)
        
        // Auto Layoutの制約を設定
        NSLayoutConstraint.activate([
            // ImageViewの制約
            bannerImageView1.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            bannerImageView1.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bannerImageView1.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bannerImageView1.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.70), // 画面高の70%をバナーの高さに設定
        ])
        
        // 画像のURL
        if let imageUrl_banner1 = URL(string: image_url_string_banner1) {
            // URLから画像を非同期でダウンロード
            URLSession.shared.dataTask(with: imageUrl_banner1) { data, response, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async { // メインスレッドでUIの更新を行う
                        bannerImageView1.image = UIImage(data: data)
                    }
                }
            }.resume() // URLSessionタスクを開始する
        }
        
    // -----[remote-config] Banner2-----
        let variable_image_url_banner2 = Variables.variable(forKey: "app_top_krt_image_url")
        let image_url_string_banner2 = variable_image_url_banner2.string(default: "url_string")
        
        let variable_label_text_banner2 = Variables.variable(forKey: "app_top_krt_label_text")
        let label_text_banner2 = variable_label_text_banner2.string(default: "label_text")
        
        let variable_button_text_banner2 = Variables.variable(forKey: "app_top_krt_button_text")
        let button_text_banner2 = variable_button_text_banner2.string(default: "button_text")
        
        let variable_link_url_banner2 = Variables.variable(forKey: "app_top_krt_link_url")
        let link_url_string_banner2 = variable_link_url_banner2.string(default: "link_url")
        
        let variable_text_color_banner2 = Variables.variable(forKey: "app_top_krt_text_color")
        let text_color_banner2 = variable_text_color_banner2.string(default: "text_color")
        
        // 遷移するURLを設定
        destinationURL2 = URL(string: link_url_string_banner2)
        
        // UIImageViewインスタンスの作成
        let bannerImageView2 = UIImageView()
        bannerImageView2.contentMode = .scaleAspectFit // 画像のアスペクト比を保ちつつfitさせる
        bannerImageView2.translatesAutoresizingMaskIntoConstraints = false
        bannerImageView2.isUserInteractionEnabled = true // ユーザーのタップを有効にする
        self.view.addSubview(bannerImageView2)
        
        let bannerLabel2 = UILabel()
        bannerLabel2.text = label_text_banner2
        bannerLabel2.textAlignment = .center
        bannerLabel2.translatesAutoresizingMaskIntoConstraints = false
        bannerLabel2.font = UIFont.boldSystemFont(ofSize: 30)
        bannerLabel2.textColor = colorWithHexString(hexString: text_color_banner2)
        bannerImageView2.addSubview(bannerLabel2)
        
        // UIButtonインスタンスの作成
        let button2 = UIButton(type: .system)
        button2.setTitle(button_text_banner2, for: .normal)
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.contentHorizontalAlignment = .left
        button2.setTitleColor(colorWithHexString(hexString: text_color_banner2), for: .normal)
        bannerImageView2.addSubview(button2) // UIImageView内に追加
        
        // タップジェスチャーの追加
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bannerTapped))
        bannerImageView2.addGestureRecognizer(tapGesture)
        
        // Auto Layoutの制約を設定
        NSLayoutConstraint.activate([
            // ImageViewの制約
            bannerImageView2.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            bannerImageView2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bannerImageView2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bannerImageView2.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25), // 画面高の25%をバナーの高さに設定
            
            // Labelの制約
            bannerLabel2.centerXAnchor.constraint(equalTo: bannerImageView2.centerXAnchor),
            bannerLabel2.centerYAnchor.constraint(equalTo: bannerImageView2.centerYAnchor),
            
            // Buttonの制約
            button2.leadingAnchor.constraint(equalTo: bannerImageView2.leadingAnchor, constant: 20), // バナーの左から20ポイントの位置
            button2.bottomAnchor.constraint(equalTo: bannerImageView2.bottomAnchor, constant: -50), // バナーの下から10ポイントの位置
            button2.heightAnchor.constraint(equalToConstant: 44) // 高さ44ポイント
        ])
        
        // 画像のURL
        if let imageUrl_banner2 = URL(string: image_url_string_banner2) {
            // URLから画像を非同期でダウンロード
            URLSession.shared.dataTask(with: imageUrl_banner2) { data, response, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async { // メインスレッドでUIの更新を行う
                        bannerImageView2.image = UIImage(data: data)
                    }
                }
            }.resume() // URLSessionタスクを開始する
        }
        
    }
    
    @objc func bannerTapped() {
        // 定義したURLを開く
        if let url = destinationURL2 {
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
