//
//  PublicQuestionToAdd.swift
//  janet.talks
//
//  Created by Coding on 10/25/21.
//

import Foundation
import UIKit

struct PublicQuestionToAdd: Hashable {
    var featuredImage: UIImage?
    var title: String?
    var question: String?
    var situationOrBackground: String?
    var tags: [String]?
    var questionImages: [UIImage]?
}
