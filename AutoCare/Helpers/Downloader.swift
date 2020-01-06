//
//  Downloader.swift
//  AutoCare
//
//  Created by Kilz on 01/01/2020.
//  Copyright © 2020 Kilz. All rights reserved.
//

import Foundation
import FirebaseStorage

let storage = Storage.storage()

//uploading Images

func UploadImages(images: [UIImage?], itemId: String, completion: @escaping (_ imageLinks: [String]) -> Void) {
    
    if Reachabilty.HasConnection() {
        var uploadImagesCount = 0
        var imageLinkArray: [String] = []
        var nameSuffix = 0
        
        for image in images {
            let filename = "ItemImages/" + itemId + "/" + "\(nameSuffix)" + ".jpg"
            let imageData = image!.jpegData(compressionQuality: 0.5)
            
            saveImageInDatabase(imageData: imageData!, fileName: filename) { (imageLink) in
                
                if imageLink != nil {
                    imageLinkArray.append(imageLink!)
                    
                    uploadImagesCount += 1
                    
                    if uploadImagesCount == images.count {
                        completion(imageLinkArray)
                    }
                }
            }
            nameSuffix += 1
        }
    }
    else {
        print("No Internet Connection")
    }
}


// Saving Image

func saveImageInDatabase(imageData: Data, fileName: String, completion: @escaping(_ imageLink: String?) -> Void) {
    
    var task : StorageUploadTask!
    
    let storageRef = storage.reference(forURL: "gs://autocare-34be1.appspot.com").child(fileName)
    
    task = storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
        
        task.removeAllObservers()
        
        if error != nil {
            print("Error Uploading Image", error!.localizedDescription)
            completion(nil)
            return
        }
        
        storageRef.downloadURL { (url, error) in
            
            guard let downloadurl = url else {
                completion(nil)
                return
            }
            completion(downloadurl.absoluteString)
        }
        
    })
}

// download Image
func downloadImages(imageurl: [String], completion: @escaping (_ images: [UIImage?]) -> Void) {
    var imageArray: [UIImage] = []
    
    var downloadCounter = 0
    
    for link in imageurl {
        
        let url = NSURL(string: link)
        
        let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
        
        downloadQueue.async {
            
            downloadCounter += 1
            
            let data = NSData(contentsOf: url! as URL)
            
            if data != nil {
                imageArray.append(UIImage(data: data! as Data)!)
                if downloadCounter == imageArray.count {
                    
                    DispatchQueue.main.async {
                        completion(imageArray)
                    }
                    
                }
            }
            else{
                print("image was not downloaded")
                completion(imageArray)
            }
        }
    }
    
}
