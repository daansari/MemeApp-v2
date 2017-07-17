//
//  ViewController.swift
//  MemeApp
//
//  Created by Danish Ahmed Ansari on 7/13/17.
//  Copyright © 2017 DeepTurf. All rights reserved.
//

import UIKit
import Foundation

class MemeCaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    //    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var topFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomFieldConstraint: NSLayoutConstraint!
    
    var originalImage: UIImage?
    var memedImage: UIImage?
    
    var viewOriginY: CGFloat = 0.0
    
    let textFieldDelegate = MemeTextFieldDelegate()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        shareButton.isEnabled = false
        
        topTextField.delegate = textFieldDelegate
        bottomTextField.delegate = textFieldDelegate
        
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -5
        ]
        
        UITextField.configure(textfield: topTextField, text: "TOP", defaultAttributes: memeTextAttributes)
        UITextField.configure(textfield: bottomTextField, text: "BOTTOM", defaultAttributes: memeTextAttributes)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewOriginY = self.view.frame.origin.y
        print("viewOriginY - \(viewOriginY)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
//    MARK: - IBAction
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        presentImagePickerWith(source: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentImagePickerWith(source: .camera)
    }
    
    func presentImagePickerWith(source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true) {
            
        }
    }
    
    @IBAction func shareAnImage(_ sender: Any) {
        memedImage = generateMemedImage()
        
        let vc = UIActivityViewController(activityItems: [memedImage!], applicationActivities: [])
        vc.completionWithItemsHandler = { (_, successful,_,_) in
            if successful {
                self.save()
            }
        }
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
//        shareButton.isEnabled = true
//        cancelButton.isEnabled = true
//
//        configure(textfield: topTextField, text: "TOP", defaultAttributes: nil)
//        configure(textfield: bottomTextField, text: "BOTTOM", defaultAttributes: nil)
//        originalImage = nil
//        memedImage = nil
//        memeImageView.image = nil
//
//        shareButton.isEnabled = false
        dismiss(animated: true, completion: nil)
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
    
    //    Move the view when keyboard covers the textfield
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y = viewOriginY - getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y = viewOriginY
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
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        let meme = Meme(dictionary: [Meme.TopText: topTextField.text!, Meme.BottomText: bottomTextField.text!, Meme.OriginalImage: originalImage!, Meme.MemedImage: memedImage!])
        appDelegate.memes.addMeme(meme: meme)

    }
    
    func generateMemedImage() -> UIImage {
        
        //        Render view to an image
        showOrHideNavBarAndToolbar(on: true)
        topFieldConstraint.constant += 10
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        showOrHideNavBarAndToolbar(on: false)
        topFieldConstraint.constant -= 10
        return memedImage
    }
    
    func showOrHideNavBarAndToolbar(on: Bool) {
        self.navigationController?.setNavigationBarHidden(on, animated: true)
        toolbar.isHidden = on
    }
    
//    MARK: - Transition Method
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        viewOriginY = self.view.frame.origin.y
        
        if UIDevice.current.orientation.isLandscape {
            bottomFieldConstraint.constant = topFieldConstraint.constant
        } else {
            bottomFieldConstraint.constant = topFieldConstraint.constant + 20
        }

    }


}

