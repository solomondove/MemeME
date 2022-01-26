//
//  ViewController.swift
//  ImagePickerTest
//
//  Created by Solomon Dove on 1/11/22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ShareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var BottomTF: UITextField!
    @IBOutlet weak var TopTF: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var NavBar: UINavigationBar!
    @IBOutlet weak var ToolBar: UIToolbar!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -4.5
    ]
    let memeDelegate = MemeTFDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if imagePickerView.image == nil {
            ShareButton.isEnabled = false
        }
        BottomTF.defaultTextAttributes = memeTextAttributes
        TopTF.defaultTextAttributes = memeTextAttributes
        TopTF.delegate = memeDelegate
        BottomTF.delegate = memeDelegate
        TopTF.text = "Top"
        BottomTF.text = "Bottom"
        BottomTF.textAlignment = NSTextAlignment.center
        TopTF.textAlignment = NSTextAlignment.center
        
        
        // Do any additional setup after loading the view.
    }
    @objc func nextTapped() {
        print("NEXT Tapped")
    }

    @IBAction func pickAnImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
            ShareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takeAnImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
   
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func save() {
        let memedImage = generateMemedImage()
//
        let saveImage = UIActivityViewController(activityItems:[memedImage], applicationActivities: nil)
        present(saveImage, animated: true, completion: nil)
    }
    func generateMemedImage() -> UIImage {
        ToolBar.isHidden = true
        NavBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        ToolBar.isHidden = false
        NavBar.isHidden = false
        
        return memedImage
    }
    
    func saveMeme(memed: UIImage){
        let meme = Meme.init(topText: TopTF.text!, bottomText: BottomTF.text!, originalImage: imagePickerView.image!, memedImage: memed)
        MemeManager.sharedInstance.appendMeme(meme: meme)
    }
}

class Meme: NSObject {
    var top: String
    var bottom: String
    var originalImage: UIImage
    
    var memedImage: UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage){
        self.top = topText
        self.bottom = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}

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
