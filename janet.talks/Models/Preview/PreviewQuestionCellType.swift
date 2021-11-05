//
//  PreviewQuestionCellType.swift
//  janet.talks
//
//  Created by Coding on 10/31/21.
//

import Foundation

enum PreviewQuestionCellType {
    case Title(viewModel: PreviewQuestionTitleViewModel)
    case Tags(viewModel: PreviewQuestionTagsViewModel)
    case Meta(viewModel: PreviewQuestionMetaViewModel)
    case Question(viewModel: PreviewQuestionQuestionBodyViewModel)
    case Background(viewModel: PreviewQuestionBackgroundViewModel)
    case Photos(viewModel: PreviewQuestionPhotosViewModel)
    case PosterInfo(viewModel: PreviewQuestionPosterInfoViewModel)
}
