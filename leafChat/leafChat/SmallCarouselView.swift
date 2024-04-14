//
//  SmallCarouselView.swift
//  leafChat
//
//  Created by Akihiro Nakano on 2024/04/15.
//

import UIKit
import KarteCore
import KarteVariables

class SmallCarouselView: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var imageUrls: [URL] = [
        URL(string: "https://img-cf.karte.io/image/660f4de80431cf867c55068c::thumbnail_b_banner_text-1.png")!,
        URL(string: "https://img-cf.karte.io/image/660f4def0431cf867c5506ad::thumbnail_b_banner_text%20%281%29.png")!,
        URL(string: "https://img-cf.karte.io/image/660f4dddc907ffc3b4f8760e::thumbnail_a_banner_only%20%281%29.png")!
    ]
    var links: [String] = ["https://example.com", "https://example.com", "https://example.com"] // リンク先のURL文字列の配列
    
    // 画像の縦横比を仮定して設定します。例: 16:9
    let aspectRatio: CGFloat = 16.0 / 9.0

    override func loadView() {
        super.loadView()
        Variables.fetch()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // UIScrollViewのインスタンス作成
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        // UIPageControlのインスタンス作成
        pageControl = UIPageControl()
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
        
        let screenWidth = view.bounds.width
        let carouselHeight = screenWidth / aspectRatio
        
        // UIScrollViewの位置とサイズを設定
        scrollView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: screenWidth, height: carouselHeight)
        scrollView.contentSize = CGSize(width: screenWidth * CGFloat(imageUrls.count), height: carouselHeight)
        
        // UIPageControlの位置をscrollViewの直下に調整
        pageControl.frame = CGRect(x: 0, y: scrollView.frame.maxY, width: screenWidth, height: 50)
        
        // イメージビューの位置とサイズを更新
        for (index, imageView) in scrollView.subviews.enumerated() where imageView is UIImageView {
            imageView.frame = CGRect(x: screenWidth * CGFloat(index), y: 0, width: screenWidth, height: carouselHeight)
        }
    }
    
    // カルーセルのコンテンツを設定するメソッド
    func setupCarousel() {
        for (index, imageUrl) in imageUrls.enumerated() {
            let imageView = UIImageView() // 位置とサイズはviewDidLayoutSubviewsで設定されます
            imageView.contentMode = .scaleAspectFit
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
