//
//  MetaLabel.swift
//  janet.talks
//
//  Created by Coding on 10/21/21.
//

import UIKit

enum HomeFeedActionButtonType {
    case love
    case comment
    case share
}

class ActionButton: UIButton {

    init(type: HomeFeedActionButtonType){
        super.init(frame: .zero)
        imageView?.contentMode = .scaleAspectFill
        tintColor = .black
        
        switch type {
        case .love:
            imageView?.image = UIImage(systemName: "heart")
        case .comment:
            imageView?.image = UIImage(systemName: "bubble.left")
        case .share:
            imageView?.image = UIImage(systemName: "paperplane")
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
