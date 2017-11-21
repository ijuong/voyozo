//
//  FinderTableViewController.swift
//  Voyozo
//
//  Created by rex on 2017. 10. 29..
//  Copyright © 2017년 ijuyong. All rights reserved.
//

import UIKit
import Foundation

class FinderTableViewController: UITableViewController {
    
    var finders:[String] = Array()
    
    func getFilePath(withFileName fileName:String) -> String {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docDir = dirPath[0] as NSString
        let filePath = docDir.appendingPathComponent(fileName)
        return filePath
    }
    
    func setFile() {
        let filePath = self.getFilePath(withFileName: "finders")
        NSKeyedArchiver.archiveRootObject(self.finders, toFile: filePath)
        //print("@@setfile: " + filePath)
    }
    
    func getFile() {
        let filePath = self.getFilePath(withFileName: "finders")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            //print("@@file path: " + filePath)
            if let finder = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [String] {
                self.finders.append(contentsOf: finder)
            }
        } else {
            //finders.append("뽀로로")
            //finders.append("캐리언니")
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
        
        return finders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //기본cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        //finder cell
        if let finderCell = cell as? FinderTableViewCell {
            let text = self.finders[indexPath.row]
            
            finderCell.finderLabel.text = text
            
            return finderCell
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            finders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            //file save
            self.setFile()
        }
    }
    
    @IBAction func FinderAdd(_ sender: Any) {
        
        let alertController = UIAlertController(title: "검색어 추가", message: "추가할 검색어를 입력하세요", preferredStyle: .alert)
        alertController.addTextField{ (textField) in
            textField.placeholder = "추가 검색어 입력"
        }
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            let textField = alertController.textFields![0]
            if let newFinderName = textField.text, newFinderName != "" {
                self.finders.append(newFinderName)
                let indexPath = IndexPath(row: self.finders.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                //file save
                self.setFile()
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

//cell에 대한 정보
class FinderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var finderLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

