//
//  MemesCollectionViewController.swift
//  MemeApp
//
//  Created by Danish Ahmed Ansari on 7/16/17.
//  Copyright © 2017 DeepTurf. All rights reserved.
//

import UIKit
import Foundation

private let reuseIdentifier = "MemeCell"

class MemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
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
        collectionView?.reloadData()
        print("memes array: \(memes.memesData)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionCellSize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.memesData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! MemeCollectionViewCell
    
        // Configure the cell
        let meme = memes.memesData[indexPath.row]
        cell.memeImageView.image = meme.originalImage
        cell.setText(label: cell.topTextLabel, text: meme.topText, memeTextAttributes: cell.getAttributesForMemeTextLabel(), textAlignment: .center)
        cell.setText(label: cell.bottomTextLabel, text: meme.bottomText, memeTextAttributes: cell.getAttributesForMemeTextLabel(), textAlignment: .center)
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = memes.memesData[indexPath.row]
        
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailVC.meme = meme
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionCellSize()
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionCellSize() {
        let space: CGFloat = 3.0
        
        let frameSize = collectionView?.frame.size
        let shorterSide = min(frameSize!.height, frameSize!.width)
        let dimension = (shorterSide - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize.init(width: dimension, height: dimension)
    }

}
