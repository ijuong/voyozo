//
//  VideoWebViewController.swift
//  Voyozo
//
//  Created by rex on 2017. 10. 30..
//  Copyright © 2017년 ijuyong. All rights reserved.
//

import UIKit

class VideoWebViewController: UIViewController, UIWebViewDelegate {

    var videoURL:String?

    @IBOutlet weak var VideoWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let youtubeURL = videoURL else {
            return
        }
        
        if let urlIns = URL(string: youtubeURL) {
            let urlRequest = URLRequest(url: urlIns)
            
            self.VideoWebView.delegate = self
            self.VideoWebView.allowsInlineMediaPlayback = false
            self.VideoWebView.mediaPlaybackRequiresUserAction = false
            self.VideoWebView.frame = self.VideoWebView.bounds
            self.VideoWebView.scalesPageToFit = true
            
            self.VideoWebView.loadRequest(urlRequest)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /*
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("@@start-----------")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("@@finish-----------")
        //self.dismiss(animated: true, completion: nil)
    }
    */
}
