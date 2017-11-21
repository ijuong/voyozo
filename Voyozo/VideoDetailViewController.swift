//
//  VideoDetailViewController.swift
//  Voyozo
//
//  Created by rex on 2017. 10. 30..
//  Copyright © 2017년 ijuyong. All rights reserved.
//

import UIKit
import AVFoundation

class VideoDetailViewController: UIViewController {
    
    var video:Video?
    var videoDetailMainImage:UIImage?

    @IBAction func videoDescription(_ sender: Any) {
        guard let descrStr = video?.descr else {
            return
        }
        
        speakToString(word: descrStr)
    }
    
    @IBOutlet weak var videoDetailTextView: UITextView!
    @IBOutlet weak var videoDetailImageView: UIImageView!
    @IBOutlet weak var videoDetailLabel: UILabel!
    
    func getThumbImage(withURL imageURL:String) -> UIImage? {
        let url:URL! = URL(string: imageURL)
        let imgData = try! Data(contentsOf: url)
        let image = UIImage(data: imgData)
        
        return image
    }
    
    func speakToString(word: String) {
        let synthesizer = AVSpeechSynthesizer()
        
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = 0.4
        
        synthesizer.speak(utterance)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        videoDetailLabel.text = video?.title
        videoDetailTextView.text = video?.descr
        
        if let mainImageURL = video?.mainImageURL {
            
            DispatchQueue.global(qos: .userInitiated).async(execute: {
                self.videoDetailMainImage = self.getThumbImage(withURL: mainImageURL)
                
                guard let thumbImage = self.videoDetailMainImage else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.videoDetailImageView.image = thumbImage
                }
                
            })
        }
        
        guard let titleStr = video?.title else {
            return
        }
        
        speakToString(word: titleStr)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let webVC = segue.destination as? VideoWebViewController {
            webVC.videoURL = self.video?.playURL
        }
    }
}
