//
//  NewsFeedView.swift
//  leafChat
//
//  Created by Akihiro Nakano on 2024/01/17.
//

import UIKit
import WebKit

class NewsFeedView: UIViewController {
    
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // make WKWebview
        webView = WKWebView(frame: view.frame)
        
        // Add WKWebView to ViewController view
        view.addSubview(webView)
        
        // button setting on navigationbar
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        let forwardButton = UIBarButtonItem(title: "Forward", style: .plain, target: self, action: #selector(forwardButtonTapped))

//        navigationItem.leftBarButtonItems = [
//            backButton
//            // ,forwardButton
//        ]
        
        // Generate url
        let url = URL(string: env.value("WKWEBVIEW_URL")!)!
        
        // Generate request
        let request = URLRequest(url: url)
        // load request
        webView.load(request)
        
    }
    
    // backbutton
    @objc func backButtonTapped() {
        webView.goBack()
    }

    // forwardbutton
    @objc func forwardButtonTapped() {
        webView.goForward()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //　Execute JavaScript
        let script = "document.querySelector('body').style.backgroundColor = 'lightblue';"
        webView.evaluateJavaScript(script, completionHandler: nil)
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
