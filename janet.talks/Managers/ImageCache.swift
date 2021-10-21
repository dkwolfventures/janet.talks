//
//  ImageCache.swift
//  janet.talks
//
//  Created by Coding on 10/20/21.
//

import Foundation
import UIKit

protocol ImageCacheType: AnyObject {
    //returns the image associated with a given url
    func image(for url: URL) -> UIImage?
    
    //Inserts the image of the specified url in the cache
    func insertImage(_ image: UIImage?, for url: URL)
    
    //removes the image of the specified url in the cache
    func removeImage(for url: URL)
    
    //removes all images from the cache
    func removeAllImage()
    
    //Accesses the value associated with the given key for reading and writing
    subscript(_ url: URL) -> UIImage? {get set}
}

final class ImageCache {
    
    static let shared = ImageCache()
    
    //1st level cache, that contains encoded images
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()
    
    //2nd level cache, that contains decoded images
    private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()
    
    private let lock = NSLock()
    private let config: Config

    struct Config {
        let countLimit: Int
        let memoryLimit: Int
        
        static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024*1024*100) //100MB
    }
    
    private init(config: Config = Config.defaultConfig){
        self.config = config
    }
}

extension ImageCache: ImageCacheType {
    func image(for url: URL) -> UIImage? {
        lock.lock()
        defer{
            lock.unlock()
        }
        
        //best case scenario -> there is a decoded image
        if let decodedImage = decodedImageCache.object(forKey: url as AnyObject) as? UIImage {
            return decodedImage
        }
        
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            let decodedImage = image.decodedImage()
            decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decodedImage.leftCapWidth * decodedImage.topCapHeight)
        }
    }
    
    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return removeImage(for: url) }
        let decodedImage = image.decodedImage()
        
        lock.lock()
        defer { lock.unlock() }
        imageCache.setObject(decodedImage, forKey: url as AnyObject)
        decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decodedImage.leftCapWidth * decodedImage.topCapHeight)
    }
    
    func removeImage(for url: URL) {
        lock.lock()
        defer{
            lock.unlock()
        }
        
        imageCache.removeObject(forKey: url as AnyObject)
        decodedImageCache.removeObject(forKey: url as AnyObject)
    }
    
    func removeAllImage() {
        <#code#>
    }
    
    subscript(url: URL) -> UIImage? {
        get {
            return image(for: url)
        }
        set {
            return insertImage(newValue, for: url)
        }
    }
    
    
}
