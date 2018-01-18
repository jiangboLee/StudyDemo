//
//  TableViewController.swift
//  UITextCheck拼写检查
//
//  Created by ljb48229 on 2018/1/18.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let words = ["devalopment", "development", "devellopment", "hello", "hello lee", "love me", "my name is lee", "my namie "];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return words.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = words[indexPath.row]
        cell.textLabel?.backgroundColor = UIColor.clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if wordIsSpelledCorrect(word: (cell?.textLabel?.text)!) {
            cell?.backgroundColor = UIColor.green
        } else {
            cell?.backgroundColor = UIColor.red
        }
        tableView.reloadData()
    }
    
    func wordIsSpelledCorrect(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.count)
        let wordRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        let ss = checker.guesses(forWordRange: range, in: word, language: "en")
        print(ss)
        return wordRange.location == NSNotFound
        
    }
}






