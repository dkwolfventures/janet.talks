//
//  AddAQuestionCellType.swift
//  janet.talks
//
//  Created by Coding on 10/25/21.
//

import Foundation

enum AddAQuestionCellType {
    case ImageAndTitle(viewModel: ImageAndTitleTableViewCellViewModel)
    case Question(viewModel: QuestionTableViewCellViewModel)
    case SituationOrBackground(viewModel: SituationOrBackgroundTableViewCellViewModel)
    case TagsAndImages(viewModel: TagsAndImagesTableViewCellViewModel)
}
