//
//  PublicQuestionHomeFeedCellType.swift
//  janet.talks
//
//  Created by Coding on 10/17/21.
//

import Foundation

enum PublicQuestionHomeFeedCellType {
    case title(viewModel: TitleCollectionViewCellViewModel)
    case Meta(viewModel: MetaCollectionViewCellViewModel)
    case Post(viewModel: PostCollectionViewCellViewModel)
    case Actions(viewModel: ActionsCollectionViewCellViewModel)
}
