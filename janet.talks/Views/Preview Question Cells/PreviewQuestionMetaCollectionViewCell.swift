//
//  PreviewQuestionMetaCollectionViewCell.swift
//  janet.talks
//
//  Created by Coding on 10/31/21.
//

import UIKit

class PreviewQuestionMetaCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    
    static let identifier = "PreviewQuestionMetaCollectionViewCell"
    
    private let metaLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    //MARK: - lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.backgroundColor = .none
        contentView.addSubview(metaLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        metaLabel.centerY(inView: contentView, paddingLeft: contentView.width/20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        metaLabel.text = "| Views: | Answers:"
    }
    
    //MARK: - actions
    
    //MARK: - helpers
    
    func configure(with viewModel: PreviewQuestionMetaViewModel){
        
        var views: String {
            
            let viewsTotal = viewModel.views
            
            switch viewsTotal {
            case ...999:
                return "\(viewsTotal)"
                
            case 1000...999999:
                return "\(CGFloat(viewsTotal / 1000))k"
                
            case 1000000...:
                return "\(CGFloat(viewsTotal / 1000000))m"
                
            default:
                fatalError()
            }
            
        }
        
        var date: String {
            
            if viewModel.datePosted.contains(Date().mediumDate.lowercased()) {
                return viewModel.datePosted.replacingOccurrences(of: Date().mediumDate.lowercased(), with: "Today")
            } else {
                return viewModel.datePosted
            }
            
        }
        
        metaLabel.text = "\(date) | Views: \(views) | Answers: \(viewModel.answers)"
        
    }
}
