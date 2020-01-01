//
//  AddItemViewController.swift
//  AutoCare
//
//  Created by Kilz on 21/12/2019.
//  Copyright © 2019 Kilz. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemViewController: UIViewController {

    //MARK: IBOutlets
    
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    
    //MARK: Vars
    var category: Category!
    var brand: Brand!
    
    var gallery: GalleryController!
    let  hud = JGProgressHUD(style: .light)
    
    var activityIndicator: NVActivityIndicatorView?
    
    var itemImages: [UIImage?] = []
    

    
    //Mark View Life cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1), padding: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func cameraButton(_ sender: Any) {
        itemImages = []
        showImageGallery()
        
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        
        dismissKeyboard()
        
        if checkFieldsIfEmpty() {
            
            saveItem()
            
        }
        else {
            print("Please fill in all fields")
        }
        
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeyboard()
    }
    
    
    //Mark: saving items to Database 

    private func saveItem() {
        
        showLoadingIndicator()
        
         let item = Item()
                
                item.id = UUID().uuidString
                item.name = titleTextField.text!
               // item.brandId = brand.id
                item.categoryId = category.id
                item.description = descriptionTextView.text
                item.price = Double(priceTextField.text!)
                
                if itemImages.count > 0 {
                    UploadImages(images: itemImages, itemId: item.id) { (imagelikArray) in
                        item.imageLinks = imagelikArray
                        
                        saveItems(item)
                        self.hideLoadingIndicator()
                        self.popView()
                    }
            
                } else
                {
                    saveItems(item)
                    popView()
                }
    }
    
    
    //helpers
    private func checkFieldsIfEmpty() -> Bool {
        
        return (titleTextField.text != "" && priceTextField.text != "" && descriptionTextView.text != "")
    }
    
    // dismissing KeyBoard
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
     
    // moving back to tableviewController
    private func popView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //Mark: show Gallery
        
    private func showImageGallery() {
           
           self.gallery = GalleryController()
           self.gallery.delegate = self
           
           Config.tabsToShow = [.imageTab, .cameraTab]
           Config.Camera.imageLimit = 6
           
           self.present(self.gallery, animated: true, completion: nil)
       }
    
    
    //Mark: Activity Indicator
    
    private func showLoadingIndicator(){
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    private func hideLoadingIndicator(){
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    
    
}

extension AddItemViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            Image.resolve(images: images) { (resolvedImages) in
                
                self.itemImages = resolvedImages
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }

    
}

