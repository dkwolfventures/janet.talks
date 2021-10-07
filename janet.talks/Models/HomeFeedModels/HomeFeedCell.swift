//
//  HomeFeedCell.swift
//  janet.talks
//
//  Created by Coding on 10/5/21.
//

import Foundation

enum HomeFeedCell {
    case publicQuestion(viewModel: PublicQuestionHomeFeedCellViewModel)
    case privateChat(viewModel: PrivateChatHomeFeedCellViewModel)
}
