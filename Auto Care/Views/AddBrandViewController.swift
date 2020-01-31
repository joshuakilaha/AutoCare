//
//  AddBrandViewController.swift
//  Auto Care
//
//  Created by Kilz on 29/01/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView


class AddBrandViewController: UIViewController {
    
    //VAR: Gallery
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .light)
    var brandImages: [UIImage?] = []
    
    //VAR: Activiry Indicator
    var activityIndicator:  NVActivityIndicatorView?
    

    @IBOutlet weak var brandName: UITextField!
    
    
    //Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 80, height: 80),type: .circleStrokeSpin, color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1),padding: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //Done Button
    @IBAction func doneButton(_ sender: Any) {
        dismissKeyboard()
        
        if checkFields() {
            savingBrand()
        }
        else {
            self.hud.textLabel.text = "Please write the Title Brand"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
        }
    }
    
    //Camera Button pressed
    @IBAction func cameraButton(_ sender: Any) {
        brandImages = []
        showImageGallery()
    }
    
    //Background Tapped
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeyboard()
        
    }
    
    
    
    
                            ///MARK:   FUNCTIONS
    
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
        
        return (brandName.text != "")
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
    
    
    /// MARK: Saving Brand
    private func savingBrand(){
        showLoadingIndicator()
        
        let brand = Brand()
        
        brand.id = UUID().uuidString
        brand.brandName = brandName.text!
        
        //adding images
        if brandImages.count > 0 {
            uploadBrandImages(images: brandImages, brandId: brand.id) { (imagelinkArrays) in
                brand.imageLinks = imagelinkArrays
                
                saveBrand(brand)
                self.hideLoadingIndicator()
                self.popView()
            }
        }
        else {
            saveBrand(brand)
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


//Camera Gallery extension

extension AddBrandViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            Image.resolve(images: images) { (resolvedImage) in
                self.brandImages = resolvedImage
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
