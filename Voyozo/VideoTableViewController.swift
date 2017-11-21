//
//  VideoTableViewController.swift
//  Voyozo
//
//  Created by rex on 2017. 10. 30..
//  Copyright © 2017년 ijuyong. All rights reserved.
//

import UIKit
import AVFoundation

class VideoTableViewController: UITableViewController {
    
    var videos:[Video] = Array()
    let maxResults = 10
    let keyStr = "AIzaSyA7CYM6ZngLaRBavttIkBVUjeX-Bfh8Z_8"
    var searchText:String = ""
    var nextPageToken:String = ""

    @IBAction func getMoreData(_ sender: Any) {
        self.getData(nextPageToken: self.nextPageToken)
        self.tableView.reloadData()
    }
    
    func speakTitle() {
        
        let synthesizer = AVSpeechSynthesizer()
        
        let utterance = AVSpeechUtterance(string: searchText)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = 0.4
        
        synthesizer.speak(utterance)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //title
        self.navigationItem.title = searchText
        
        //tts
        speakTitle()
        
        //youtube api get data
        self.getData(nextPageToken: self.nextPageToken)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        //video cell
        if let videoCell = cell as? VideoTableViewCell {
            let videoTitle = self.videos[indexPath.row].title
            
            //textview
            videoCell.videoLabel.text = videoTitle
            
            //image
            if let thumbImage = videos[indexPath.row].thumbImage {
                
                videoCell.videoImageView?.image = thumbImage
            } else {
                if let thumbImageURL = videos[indexPath.row].thumbImageURL {
                    
                    DispatchQueue.global(qos: .userInitiated).async(execute: {
                        self.videos[indexPath.row].thumbImage = self.getThumbImage(withURL: thumbImageURL)
                        
                        guard let thumbImage = self.videos[indexPath.row].thumbImage else {
                            return
                        }
                        
                        DispatchQueue.main.async {
                            videoCell.videoImageView?.image = thumbImage
                        }
                        
                    })
                }
            }
            
            return videoCell
        }
        
        return cell
    }
    
    func getThumbImage(withURL imageURL:String) -> UIImage? {
        let url:URL! = URL(string: imageURL)
        let imgData = try! Data(contentsOf: url)
        let image = UIImage(data: imgData)
        
        return image
    }
    
    func getData(nextPageToken:String) {
        
        let urlStr = "https://www.googleapis.com/youtube/v3/search?part=snippet&order=relevance&q=\(searchText)&key=\(keyStr)&maxResults=\(maxResults)&pageToken=\(nextPageToken)"
        let encoded = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let serverURL:URL! = URL(string: encoded!)
        let serverData = try! Data(contentsOf: serverURL)
        //let log = NSString(data: serverData, encoding: String.Encoding.utf8.rawValue)
        //print(log)
        
        do {
            //pasing
            let dict = try JSONSerialization.jsonObject(with: serverData, options: []) as! NSDictionary
            
            //nextPageToken
            if let nextPageTokenStr = dict["nextPageToken"] as? String {
                self.nextPageToken = nextPageTokenStr
            }
            
            //items
            let items = dict["items"] as! NSArray
            //let results = items["snippet"] as! NSDictionary
            
            for item in items {
                let itemDict = item as! NSDictionary
                //id
                let idDict = itemDict["id"] as! NSDictionary
                let videoIdStr:String? = idDict["videoId"] as? String
                //snippet
                let snippetDict = itemDict["snippet"] as! NSDictionary
                
                //thumbnails
                let thumbnailsDict = snippetDict["thumbnails"] as! NSDictionary
                let thumbDefDict = thumbnailsDict["default"] as! NSDictionary
                let thumbMedDict = thumbnailsDict["medium"] as! NSDictionary
                
                // create video class
                let p_title:String? = snippetDict["title"] as? String
                let p_thumbImageURL:String? = thumbDefDict["url"] as? String
                let p_mainImageURL:String? = thumbMedDict["url"] as? String
                let p_descr:String? = snippetDict["description"] as? String
                var p_playURL:String = "";
                if videoIdStr != nil {
                    p_playURL = "https://www.youtube.com/embed/" + videoIdStr! + "?rel=0&autoplay=1&modestbranding=0&autohide=0showinfo=0"
                }

                let video = Video(title: p_title,
                                  thumbImage: nil,
                                  thumbImageURL: p_thumbImageURL,
                                  mainImageURL: p_mainImageURL,
                                  descr: p_descr,
                                  playURL: p_playURL)
                
                videos.append(video)
                //print("@@ title=\(p_title) thumbImage=\(p_thumbImage) mainImage=\(p_mainImage) descr=\(p_descr) playURL=\(p_playURL)")
            }
            //print(dict)
        } catch {
            print("Error")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailvc" {
            
            let cell = sender as? UITableViewCell
            let vc = segue.destination as? VideoDetailViewController
            
            guard let selectedCell = cell, let detailVC = vc else {
                return
            }
            
            if let idx = self.tableView.indexPath(for: selectedCell) {
                detailVC.video = self.videos[idx.row]
            }
        }
    }
    
    func sendNewVideo(video:Video) {
        self.videos.append(video)
        self.tableView.reloadData()
    }
}

//cell에 대한 정보
class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var videoImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
