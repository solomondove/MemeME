//
//  MemeDetailViewController.swift
//  MemeME
//
//  Created by Solomon Dove on 2/1/22.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    @IBOutlet weak var memeImage: UIImageView!
    var meme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.memeImage?.image = meme.memedImage
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
