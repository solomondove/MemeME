//
//  SentMemeCollectionViewController.swift
//  MemeME
//
//  Created by Solomon Dove on 1/31/22.
//

import Foundation
import UIKit

class SentMemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send Meme", style: .plain, target: self, action: #selector(sendNew))
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    @objc func sendNew() {
        let newMemeVC = storyboard?.instantiateViewController(withIdentifier: "NewMemeViewController")as! NewMemeViewController
        self.navigationController?.pushViewController(newMemeVC, animated:true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! MemeCollectionViewCell
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        cell.memeImageView?.image = meme.memedImage
        return cell 
    }
    
}
