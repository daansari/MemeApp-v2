//
//  ViewController.swift
//  MemeApp
//
//  Created by Danish Ahmed Ansari on 7/13/17.
//  Copyright © 2017 DeepTurf. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    //    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    var originalImage: UIImage?
    var memedImage: UIImage?
    
    var scrollViewOriginY: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scrollViewOriginY = self.view.frame.origin.y
        print("scrollViewOriginY - \(scrollViewOriginY)")
        
        subscribeToKeyboardNotifications()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -5
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        
        topTextField.borderStyle = .none
        bottomTextField.borderStyle = .none
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    MARK: - IBAction
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true) {
            
        }
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareAnImage(_ sender: Any) {
        save()
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        shareButton.isEnabled = true
        cancelButton.isEnabled = true
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        originalImage = nil
        memedImage = nil
        memeImageView.image = nil
        
        shareButton.isEnabled = false
    }
    
    // MARK: - Image Picker Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image: UIImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            memeImageView.image = image
            originalImage = image
            
            shareButton.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //    MARK: - Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    //    Move the view when keyboard covers the textfield
    func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y = scrollViewOriginY - getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y = scrollViewOriginY
        }
    }
    
//    Get Keyboard Height
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
//    MARK: - Memed Image Save and Share
    func save() {
        memedImage = generateMemedImage()
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: originalImage!, memedImage: memedImage!)
        print ("meme - \(meme)")
        
        let vc = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        //        Render view to an image
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        toolbar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        toolbar.isHidden = false
        return memedImage
    }
    
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
        
        init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
            self.topText = topText
            self.bottomText = bottomText
            self.originalImage = originalImage
            self.memedImage = memedImage
        }
    }
    
//    MARK: - Transition Method
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            scrollViewOriginY = self.view.frame.origin.y
        } else {
            print("Portrait")
            scrollViewOriginY = self.view.frame.origin.y
        }
    }


}

