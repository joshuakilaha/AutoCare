//
//  ItemViewController.swift
//  Auto Care
//
//  Created by Kilz on 06/02/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import UIKit
import JGProgressHUD

class ItemViewController: UIViewController {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var itemNameText: UILabel!
    @IBOutlet weak var itemDescriptionText: UITextView!
    @IBOutlet weak var ItemPriceText: UILabel!
    @IBOutlet weak var sellerNameText: UILabel!
    @IBOutlet weak var sellerPhoneNumber: UILabel!
    
    //Mark: VARS
    
    //var cart: Cart?
    var brand: Brand!
    var category: Category!
    var item: Item!
    var itemImages: [UIImage] = []
    let hud = JGProgressHUD(style: .light)
    
    
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    private let cellHeight: CGFloat = 300.0
    private let itemsPerRow: CGFloat = 1
    
    
    //Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SetupItemUI()
        DownloadItemImage()
        
      //Back Button
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backAction))]
        
    //Cart Button
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "basket"), style: .plain, target: self, action: #selector(self.AddCart))]
        
        
        
        print("item name: ",item.itemName!)
        
        // Do any additional setup after loading the view.
        
    }
    
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func AddCart() {
        //check if user is logged in
        
        if User.currentUser() != nil {
            
            downloadCartFromDatabase(User.currentID()) { (cart) in
                if cart == nil {
                    self.createCartForNewUser()
                }
                else {
                    cart!.itemIds.append(self.item.id)
                    self.updateCart(cart: cart!, withValues: [cItemIds : cart!.itemIds])
                }
            }

        } else {
            showLoginView()
        }
        

    }
    
                        //MARK: FUNCTION
    
    //Getting Item from db
    private func SetupItemUI () {
        
        if item != nil {
            
            let ownerPhoneNumber = "0\(item.phoneNumber ?? "Phone")"
            self.title = item.itemName
            itemNameText.text = item.itemName
            itemDescriptionText.text = item.description
            ItemPriceText.text = convertCurrency(item.price)
            sellerNameText.text = item.owner
            sellerPhoneNumber.text = ownerPhoneNumber
            
            //TO DO: Hide Seller and Phone Number Lable
            if User.currentUser() == nil {
                sellerNameText.isHidden = true
                sellerPhoneNumber.isHidden = true
            }
        }
    }
    
    
    //Getting Item image frm db
    private func DownloadItemImage() {
         
        if item != nil && item.imageLinks != nil {
            downloadImages(imageurls: item.imageLinks) { (allimages) in
                if allimages.count > 0 {
                    self.itemImages = allimages as! [UIImage]
                    self.imageCollectionView.reloadData()
                }
            }
        }
    }
    
    
    //Login
    
    private func showLoginView() {
        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
        
        self.present(loginView, animated: true, completion: nil)
    }
    
    
    //Adding to Cart
    
    
    private func createCartForNewUser() {
        
        let newCart = Cart()
        newCart.id = UUID().uuidString
        newCart.userId = User.currentID()
        newCart.itemIds = [self.item.id]
        newCart.brandId = brand?.id
        newCart.categoryId = category?.id
        savingCartToDatabase(newCart)
        
        
        self.hud.textLabel.text = "Item added to Cart"
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 3.0)
        
        
    }
    
    private func updateCart(cart: Cart, withValues: [String: Any]) {
        
        updateCartInDatabase(cart, withValues: withValues) { (error) in
            if error != nil {
                
                self.hud.textLabel.text = "Error: \(error!.localizedDescription)"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 3.0)
                
                print("error when updating cart", error!.localizedDescription)
            }
            else {
                
                self.hud.textLabel.text = "Item added to Cart"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 3.0)
            }
        }
    }
}


//MARK: EXTENSIONS


extension ItemViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count == 0 ? 1 : itemImages.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        
        if itemImages.count > 0 {
            cell.setUpItemImageView(itemImage: itemImages[indexPath.row])
        }
        
        return cell
        
    }
    
    
}

extension ItemViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - sectionInsets.left
        return CGSize(width: width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
