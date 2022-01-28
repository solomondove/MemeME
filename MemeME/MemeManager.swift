//
//  MemeManager.swift
//  MemeME
//
//  Created by Solomon Dove on 1/26/22.
//

import Foundation
import UIKit
class MemeManager: NSObject {
    static let sharedInstance: MemeManager = { MemeManager() }()

    var memes: [Meme]

    override init () {
        memes = []
    }

    func deleteMemeAtIndex(index: Int){
        memes.remove(at: index)
    }

    func appendMeme(meme: Meme){
        memes.append(meme)
    }
}
