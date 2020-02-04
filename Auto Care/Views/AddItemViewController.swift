//
//  AddItemViewController.swift
//  Auto Care
//
//  Created by Kilz on 04/02/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemViewController: UIViewController {

    
    @IBOutlet weak var itemNameText: UITextField!
    @IBOutlet weak var itemPriceText: UITextField!
    @IBOutlet weak var itemDescriptionText: UITextView!
    
    
    
    //MARK: Vars
    var category: Category!
    var brand: Brand!
    
    var gallery: GalleryController!
    let  hud = JGProgressHUD(style: .light)
    
    var activityIndicator: NVActivityIndicatorView?
    
    var itemImages: [UIImage?] = []
    
    //life cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .circleStrokeSpin, color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), padding: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("AddItem show BrandId: ", brand?.id)
        print("Category ID is: ", category?.id)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backgroundTapped(_ sender: Any) {
         dismissKeyboard()
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        itemImages = []
        showImageGallery()
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        dismissKeyboard()
        if checkFields() {
            SavingItem()
            
        }
        else {
            self.hud.textLabel.text = "Please fill in all fields"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
            
        }
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
        
        return (itemNameText.text != "" && itemPriceText.text != "" && itemDescriptionText.text != "")
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
    
    
    
    //Mark: Saving Item
    
    private func SavingItem(){
        showLoadingIndicator()
        
        let item = Item()
        
        item.id = UUID().uuidString
        item.itemName = itemNameText.text!
        item.brandId = brand.id
        item.categoryId = category.id
        item.description = itemDescriptionText.text
        item.price = Double(itemPriceText.text!)
        
        
        if itemImages.count > 0 {
            uploadItemImages(images: itemImages, itemId: item.id) { (imageLinksArray) in
                item.imageLinks = imageLinksArray
                
                SaveItem(item)
                self.hideLoadingIndicator()
                self.popView()
            }
        }
        else {
            SaveItem(item)
            popView()
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension AddItemViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
         if images.count > 0 {
                   Image.resolve(images: images) { (resolvedImage) in
                       self.itemImages = resolvedImage
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
