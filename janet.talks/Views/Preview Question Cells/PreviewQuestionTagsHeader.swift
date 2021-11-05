//
//  CollectionReusableView.swift
//  janet.talks
//
//  Created by Coding on 11/1/21.
//

import UIKit

class PreviewQuestionTagsHeader: UICollectionViewCell{
    //MARK: - properties
    static let identifier = "PreviewQuestionTagsHeader"
    var tagsView: TagGroupView?
    
    //MARK: - lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tagsView?.bindToSuperview()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        tagsView = nil
        self.setup(tags: [])
        
    }
    
    //MARK: - actions
    
    //MARK: - helpers
    
    public func setup(tags: [String]){
        
        let tagsView = TagGroupView()
        addSubview(tagsView)
        self.tagsView = tagsView
        var tagsArr = [Tag]()
        
        for tag in tags {
            let newTag = Tag(tag: tag, isFollowing: false)
            tagsArr.append(newTag)
        }
        
        
        let allTags = TagGroup(tags: [tagsArr])

        tagsView.setup(with: allTags)
        
    }
}
