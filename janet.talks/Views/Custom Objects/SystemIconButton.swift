//
//  SystemIconButton.swift
//  janet.talks
//
//  Created by Coding on 10/4/21.
//

import UIKit

class SystemIconButton: UIButton {
    
    init(iconName: String, iconColor: UIColor? = .label){
        super.init(frame: .zero)
        
        setImage(UIImage(systemName: iconName), for: .normal)
        tintColor = iconColor
        imageView?.fillSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
