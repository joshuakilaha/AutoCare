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
    var user: User!
    
    var allItems: [Category] = []
    var UserItemsIds: [String] = []
    
    var gallery: GalleryController!
    let  hud = JGProgressHUD(style: .light)
    
    var activityIndicator: NVActivityIndicatorView?
    
    var itemImages: [UIImage?] = []
    
    //life cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .circleStrokeSpin, color: #colorLiteral(red: 0.2, green: 0.2, blue: 0.6, alpha: 1), padding: nil)
    
        print("User ID:", User.currentID())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("AddItem show BrandId: ", brand?.id as Any)
        print("Category ID is: ", category?.id as Any)
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
    
                            //MARK: loading indicator
    
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
    
                                //MARK: gallery
    
    //show Gallery
    private func showImageGallery(){
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 6
        self.present(self.gallery, animated: true, completion: nil)
    }
    
    
    
                                //MARK: saving item
    
    private func SavingItem(){
        showLoadingIndicator()
        
        let item = Item()
        
        let ownerId = User.currentID()
        let owner = User.currentUser()
        let ownerPhoneNumber  = User.currentUser()
        
    
        item.id = UUID().uuidString
        item.itemName = itemNameText.text!
        item.brandId = brand.id
        item.categoryId = category.id
        item.description = itemDescriptionText.text
        item.price = Double(itemPriceText.text!)
        item.userId = ownerId
        item.owner = owner?.fullName
        item.phoneNumber = ownerPhoneNumber?.phoneNumber
        UserItemsIds.append(item.id)
       

        
        if itemImages.count > 0 {
            uploadItemImages(images: itemImages, itemId: item.id) { (imageLinksArray) in
                item.imageLinks = imageLinksArray
                
                self.addItemsToUserLibrary(self.UserItemsIds)
                SaveItem(item)
                saveItemToAngolia(item: item)
                self.hideLoadingIndicator()
                self.popView()
            }
        }
        else {
            self.addItemsToUserLibrary(self.UserItemsIds)
            SaveItem(item)
            saveItemToAngolia(item: item)
            popView()
        }
    }
    
    private func addItemsToUserLibrary(_ itemIds: [String]){
        if User.currentUser() != nil {
            let newItemId = User.currentUser()!.userItems + itemIds
            updateCurrentUserFromDatabase(withValues: [cUserItems: newItemId]) { (error) in
                if error != nil {
                    print("Error adding Item", error!.localizedDescription)
                }
            }
        }
    }
}


//MARK: EXTENSIONS

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
