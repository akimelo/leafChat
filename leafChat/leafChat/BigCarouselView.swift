//
//  BigCarouselView.swift
//  leafChat
//
//  Created by Akihiro Nakano on 2024/04/14.
//

import UIKit
import KarteCore
import KarteVariables

class BigCarouselView: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var imageUrls: [URL] = [] // URL配列の宣言だけする
    var links: [String] = [] // リンク先のURL文字列の配列を宣言だけする
    let carouselHeight: CGFloat = 200 // カルーセルの高さを設定
    
    override func loadView() {
        super.loadView()
        Variables.fetch()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    // -----[remote-config] Big Carousel-----
        // Variablesの確認
        let keys = Variables.getAllKeys()
        print(keys)
        
        let variable_image_url_0_carousel = Variables.variable(forKey: "account_top_krt_image_url_0")
        let image_url_0_string_carousel = variable_image_url_0_carousel.string(default: "image_url_0_string")
        
        let variable_image_url_1_carousel = Variables.variable(forKey: "account_top_krt_image_url_1")
        let image_url_1_string_carousel = variable_image_url_1_carousel.string(default: "image_url_1_string")
        
        let variable_image_url_2_carousel = Variables.variable(forKey: "account_top_krt_image_url_2")
        let image_url_2_string_carousel = variable_image_url_2_carousel.string(default: "image_url_2_string")
        
        let variable_link_url_0_carousel = Variables.variable(forKey: "account_top_krt_link_url_0")
        let link_url_0_string_carousel = variable_link_url_0_carousel.string(default: "link_url_0_string")
        
        let variable_link_url_1_carousel = Variables.variable(forKey: "account_top_krt_link_url_1")
        let link_url_1_string_carousel = variable_link_url_1_carousel.string(default: "link_url_1_string")
        
        let variable_link_url_2_carousel = Variables.variable(forKey: "account_top_krt_link_url_2")
        let link_url_2_string_carousel = variable_link_url_2_carousel.string(default: "link_url_2_string")
        
        // imageUrlsとlinksにfetchした値を代入
        imageUrls = [
            URL(string: image_url_0_string_carousel)!,
            URL(string: image_url_1_string_carousel)!,
            URL(string: image_url_2_string_carousel)!
        ]
        links = [
            link_url_0_string_carousel,
            link_url_1_string_carousel,
            link_url_2_string_carousel
        ]
        
        // UIScrollViewのインスタンス作成
        scrollView = UIScrollView(frame: CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: carouselHeight))
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(imageUrls.count), height: carouselHeight)
        
        // 各画像とタップジェスチャーの追加
        for (index, imageUrl) in imageUrls.enumerated() {
        let imageView = UIImageView(frame: CGRect(x: view.frame.width * CGFloat(index), y: 0, width: view.frame.width, height: carouselHeight)) // カルーセルの高さを設定)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            
            // 画像のダウンロード
            downloadImage(url: imageUrl) { image in
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imageView.addGestureRecognizer(tapGesture)
            imageView.tag = index
            
            scrollView.addSubview(imageView)
        }
        
        // UIPageControlのインスタンス作成
        pageControl = UIPageControl(frame: CGRect(x: 0, y: scrollView.frame.maxY, width: view.frame.width, height: 50))
        pageControl.numberOfPages = imageUrls.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
        
        // Viewに追加
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        
        // カルーセルのコンテンツを設定
        setupCarousel()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // セーフエリアのトップインセットを考慮してscrollViewの位置を調整
        scrollView.frame.origin.y = view.safeAreaInsets.top
        // UIPageControlの位置をscrollViewの直下に調整
        pageControl.frame.origin.y = scrollView.frame.maxY
    }
    
    // カルーセルのコンテンツを設定するメソッド
    func setupCarousel() {
       scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(imageUrls.count), height: carouselHeight)
       // 各画像とタップジェスチャーの追加
       for (index, imageUrl) in imageUrls.enumerated() {
           let imageView = UIImageView(frame: CGRect(x: view.frame.width * CGFloat(index), y: 0, width: view.frame.width, height: carouselHeight))
           imageView.contentMode = .scaleAspectFill
           imageView.clipsToBounds = true
           imageView.isUserInteractionEnabled = true
           // 画像のダウンロード
           downloadImage(url: imageUrl) { image in
               DispatchQueue.main.async {
                   imageView.image = image
               }
           }
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
           imageView.addGestureRecognizer(tapGesture)
           imageView.tag = index
           scrollView.addSubview(imageView)
       }
    }
    
    // 画像がタップされた時のアクション
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        if let index = sender.view?.tag {
//            let index = imageView.tag
            let link = links[index]
            // ここでURLを開くなどのアクションを行う
            if let url = URL(string: link) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    // ページが変更された時のアクション
    @objc func pageControlChanged(_ sender: UIPageControl) {
        let page = sender.currentPage
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    // UIScrollViewのスクロールが終わった後に呼ばれるデリゲートメソッド
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = page
    }
    
    // URLから画像をダウンロードする関数
    func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
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
