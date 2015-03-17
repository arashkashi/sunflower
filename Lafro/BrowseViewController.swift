//
//  BrowseViewController.swift
//  Lafro
//
//  Created by Arash K. on 11/03/15.
//  Copyright (c) 2015 Arash K. All rights reserved.
//

import UIKit


class BrowseViewController: GAITrackedViewController, UITableViewDataSource, BrowseCellDelegate {
    
    var learningPackModel: LearningPackModel!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsetsMake(-70, 0, 0, 0);
        self.tableView.backgroundColor = UIColor.blackColor()
        self.tableView.backgroundView?.backgroundColor = UIColor.blackColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.screenName = "BrowseViewController"
    }
    
    // MARK: Delegate
    func onCellResetTapped(indexPath: NSIndexPath) {
        var word = learningPackModel.words[indexPath.row]
        word.resetLearing()
        self.learningPackModel.saveChanges()
        tableView.reloadData()
    }
    
    func onCellRemoveTapped(indexPath: NSIndexPath) {
        if learningPackModel.words.count == 5 {
            return
        } else {
            var word = learningPackModel.words[indexPath.row]
            learningPackModel.removeWord(word)
            tableView.reloadData()
        }
    }

    // MARK: Table View data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return learningPackModel.words.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("browse_word_cell") as? BrowseTableViewCell
        cell?.updateWithWord(self.learningPackModel.words[indexPath.row], indexPath: indexPath)
        cell?.delegate = self
        
        return cell!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
