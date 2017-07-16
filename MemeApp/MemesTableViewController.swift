//
//  MemesTableViewController.swift
//  MemeApp
//
//  Created by Danish Ahmed Ansari on 7/16/17.
//  Copyright © 2017 DeepTurf. All rights reserved.
//

import UIKit

class MemesTableViewController: UITableViewController {
    
    var memes = Memes()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        tableView.reloadData()
        print("memes array: \(memes.memesData)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.memesData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath) as! MemeTableViewCell

        // Configure the cell...
        let meme = memes.memesData[indexPath.row]
        cell.memeImageView.image = meme.originalImage
        let text = "\(meme.topText) \(meme.bottomText)"
        cell.setText(label: cell.memeTextLabel, text: text, memeTextAttributes: cell.getAttributesForTextLabel(), textAlignment: .left)
        cell.setText(label: cell.topTextLabel, text: meme.topText, memeTextAttributes: cell.getAttributesForMemeTextLabel(), textAlignment: .center)
        cell.setText(label: cell.bottomTextLabel, text: meme.bottomText, memeTextAttributes: cell.getAttributesForMemeTextLabel(), textAlignment: .center)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes.memesData[indexPath.row]
        
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailVC.meme = meme
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
