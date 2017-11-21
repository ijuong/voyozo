//
//  SearchTableViewController.swift
//  Voyozo
//
//  Created by rex on 2017. 10. 29..
//  Copyright © 2017년 ijuyong. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    var searchList:[String] = Array()
    
    func getFilePath(withFileName fileName:String) -> String {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docDir = dirPath[0] as NSString
        let filePath = docDir.appendingPathComponent(fileName)
        return filePath
    }
    
    func getFile() {
        let filePath = self.getFilePath(withFileName: "finders")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            if let search = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [String] {
                self.searchList.append(contentsOf: search)
            }
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //파일조회
        getFile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        //finder cell
        if let searchListCell = cell as? SearchTableViewCell {
  
            let text = self.searchList[indexPath.row]
            let idx:String = String(indexPath.row % 10)
            searchListCell.searchListLabel.text = text
            searchListCell.searchListImageView.image = UIImage(named:"list" + idx)
            
            return searchListCell
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "listvc" {
            
            let cell = sender as? SearchTableViewCell
            let vc = segue.destination as? VideoTableViewController
            
            guard let selectedCell = cell, let detailVC = vc else {
                return
            }
            
            detailVC.searchText = selectedCell.searchListLabel.text!
        }
    }
}

//cell에 대한 정보
class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchListLabel: UILabel!
    
    @IBOutlet weak var searchListImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    } 
}
