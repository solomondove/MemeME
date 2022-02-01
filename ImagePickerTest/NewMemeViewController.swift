//
//  ViewController.swift
//  ImagePickerTest
//
//  Created by Solomon Dove on 1/11/22.
//

import UIKit

class NewMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ShareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var BottomTF: UITextField!
    @IBOutlet weak var TopTF: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var NavBar: UINavigationBar!
    @IBOutlet weak var ToolBar: UIToolbar!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -4.5
    ]
    let memeDelegate = MemeTFDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()

        if imagePickerView.image == nil {
            ShareButton.isEnabled = false
        }
        setMemeTextField(BottomTF, text: "Bottom")
        setMemeTextField(TopTF, text: "Top")

        // Do any additional setup after loading the view.
    }

    func setMemeTextField(_ textField: UITextField, text: String){
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = memeDelegate
        textField.text = text
        textField.textAlignment = NSTextAlignment.center
    }

    @objc func nextTapped() {
        print("NEXT Tapped")
    }

    @IBAction func pickAnImage(_ sender: Any) {
        presentPickerViewController(source: .photoLibrary)
    }

    func presentPickerViewController(source: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
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
        presentPickerViewController(source: .camera)
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
//        if BottomTF.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
//        }

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
        let saveImage = UIActivityViewController(activityItems:[memedImage], applicationActivities: nil)
        saveImage.completionWithItemsHandler = {
            (activity, completed, items, error) in
            if completed {
                self.saveMeme(memed: memedImage)
                self.navigationController?.popToRootViewController(animated: true)
                print("made it here")
            }
        }
        present(saveImage, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        hideAndShowBars(answer: true)

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()


        hideAndShowBars(answer: false)

        return memedImage
    }

    func hideAndShowBars(answer: Bool){
        ToolBar.isHidden = answer
        NavBar.isHidden = answer
    }

    func saveMeme(memed: UIImage){
        let meme = Meme.init(topText: TopTF.text!, bottomText: BottomTF.text!, originalImage: imagePickerView.image!, memedImage: memed)
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        print((UIApplication.shared.delegate as! AppDelegate).memes)
        print("saved")
    }
}

