//
//  TagButton.swift
//  janet.talks
//
//  Created by Coding on 11/7/21.
//

import UIKit

class TagButton: UIButton {
    
    public var following: Bool

    init(title: String, following: Bool){
        self.following = following
        super.init(frame: .zero)
        setTitle(title, for: .normal)
            
        if following {
            configureForFollowed()
        } else {
            configureForNotFollowed()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureForFollowed(){
        
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseForegroundColor = .label
        configuration.imagePadding = 15
        configuration.baseBackgroundColor = .logoGreen
        configuration.image = UIImage(systemName: "checkmark")
        self.configuration = configuration
        
    }
    
    public func configureForNotFollowed(){
        
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseForegroundColor = .label
        configuration.imagePadding = 15
        configuration.baseBackgroundColor = .systemBackground
        configuration.image = UIImage(systemName: "plus")
        self.configuration = configuration
        
    }
    
}
