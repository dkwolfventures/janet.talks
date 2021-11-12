//
//  StorageManager.swift
//  janet.talks
//
//  Created by Coding on 10/5/21.
//

import Foundation
import Firebase
import UIKit

final class StorageManager {
    
    //MARK: - setup singleton
    static let shared = StorageManager()
    
    private init(){}
    
    private let storage = Storage.storage().reference()
    
    //MARK: - public stuff
    
    public func profilePictureURL(for username: String, completion: @escaping (URL?) -> Void) {
        storage.child("\(username)/profile_picture.png").downloadURL { url, _ in
            completion(url)
        }
    }
    
    public func uploadFeaturedImage(customImage: UIImage, questionID: String, completion: @escaping(Result<URL?, Error>) -> Void){
        
        let ref = storage.child("\(questionID)/featured_image.png")
        
        guard let data = customImage.jpegData(compressionQuality: 0.5) else {return}
        
        ref.putData(data, metadata: nil) { _, error in
            
            if let error = error {
                completion(.failure(error))
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                completion(.success(url))
            }
            
        }
        
    }
    
    public func uploadQuestionImage(photo: UIImage, imageId: String, completion: @escaping(Result<String?, Error>) -> Void){
        
        guard let data = photo.jpegData(compressionQuality: 0.50) else {return}
        
        let ref = storage.child("\(PersistenceManager.shared.username)/public-q-photos/\(imageId).png")
        
        ref.putData(data, metadata: nil) { _, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let url = url else {return}
                print("debug: these are the photo urls \(url.absoluteString)")
                completion(.success(url.absoluteString))
            }
        }
        
    }
    
    public func uploadQuestionImages(photos: [UIImage], questionId: String){
        
        var urlStrings = [String]()
        
        for (idx, photo) in photos.enumerated() {
            
            if idx >= 16 {
                break
            }
            
            guard let data = photo.jpegData(compressionQuality: 0.50) else {return}
            
            let ref = storage.child("\(PersistenceManager.shared.username)/public-q-photos/\(questionId)\(idx).png")
            
            ref.putData(data, metadata: nil){ _, _ in
                
                ref.downloadURL { url, _ in
                    
                    guard let url = url else {return}
                    
                    urlStrings.append(url.absoluteString)
                    
                    DatabaseManager.shared.uploadURLsToPostedQuestion(qId: questionId, urls: urlStrings)
                }
                
            }
        }
        
    }
    

}
