//
//  AddCategoryViewController.swift
//  Auto Care
//
//  Created by Kilz on 31/01/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddCategoryViewController: UIViewController {
    
    var brand: Brand!
    
    //MARK: VAR: Gallery
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .light)
    var categoryImages: [UIImage?] = []
    
    //MARK: VAR: Activity Indicator
    var activityIndicator:  NVActivityIndicatorView?
    

    @IBOutlet weak var categoryTitle: UITextField!
    
    //Life cycle
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           
           activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 80, height: 80),type: .circleStrokeSpin, color: #colorLiteral(red: 0.2, green: 0.2, blue: 0.6, alpha: 1),padding: nil)
           
       }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Brand Id to be added: ", brand?.id)
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        
        dismissKeyboard()
        
        if checkFields() {
            savingCategory()
        }
        else {
            self.hud.textLabel.text = "Please write the Title Brand"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
        }
        
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        categoryImages = []
        showImageGallery()
    }
    
    
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeyboard()
    }
    

    
    //MARK:   FUNCTIONS
       
       //dismissing keyboard
       private func dismissKeyboard(){
           self.view.endEditing(false)
       }
       
       //moving back to Brands
       private func popView(){
           self.navigationController?.popViewController(animated: true)
       }
       
       //checking text fields
       private func checkFields() -> Bool {
           
           return (categoryTitle.text != "")
       }
       
                       //loading indicator
       
       //showing loading Indicator
       
       private func showLoadingIndicator(){
           if activityIndicator != nil {
               self.view.addSubview(activityIndicator!)
               activityIndicator!.startAnimating()

           }
         
       }
       
       //Hide loading Indicator
       private func hideLoadingIndicator(){
           if activityIndicator != nil {
               activityIndicator!.removeFromSuperview()
               activityIndicator!.stopAnimating()
               
           }
       }
       
       //show Gallery
       private func showImageGallery(){
           self.gallery = GalleryController()
           self.gallery.delegate = self
           
           Config.tabsToShow = [.imageTab, .cameraTab]
           Config.Camera.imageLimit = 1
           self.present(self.gallery, animated: true, completion: nil)
       }
       
       
       // MARK: Saving Brand
       private func savingCategory(){
           showLoadingIndicator()
           
           let category = Category()
           
           category.id = UUID().uuidString
           category.brandId = brand?.id
           category.categoryName = categoryTitle.text!
           
           //adding images
        if categoryImages.count > 0 {
            uploadCategoryImages(images: categoryImages, categoryId: category.id) { (imageCategoryArray) in
                category.imageLinks = imageCategoryArray
                
                saveCategory(category)
                self.hideLoadingIndicator()
                self.popView()
            }
        }
       }
    
}



extension AddCategoryViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        
        if images.count > 0 {
            Image.resolve(images: images) { (resolvedImage) in
                self.categoryImages = resolvedImage
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

