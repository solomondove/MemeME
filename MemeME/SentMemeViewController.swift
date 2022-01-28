//
//  SentMemeViewController.swift
//  MemeME
//
//  Created by Solomon Dove on 1/27/22.
//

import Foundation
import UIKit

class SentMemeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let memes = MemeManager.sharedInstance.memes
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send Meme", style: .plain, target: self, action: #selector(sendNew))
    }
    
    @objc func sendNew() {
        let newMemeVC = storyboard?.instantiateViewController(withIdentifier: "NewMemeViewController")as! NewMemeViewController
        self.navigationController?.pushViewController(newMemeVC, animated:true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.top
        
        return cell
    }
}
