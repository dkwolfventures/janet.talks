//
//  LogoImageView.swift
//  janet.talks
//
//  Created by Coding on 10/19/21.
//

import UIKit

class LogoImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        image = UIImage(named: "logo")
        contentMode = .scaleAspectFit
        layer.cornerCurve = .continuous
        layer.cornerRadius = 8
        layer.masksToBounds = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
