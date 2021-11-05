//
//  TagGroupView.swift
//  janet.talks
//
//  Created by Coding on 11/1/21.
//

import UIKit

class TagGroupView: UIView {
    
    //MARK: - properties
    
    private var rows = [UIScrollView]()
    private var minRowWidth: CGFloat = 0
    private var minRowOffset: CGFloat = 0
    
    private var groupStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    
    private var transparentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    //MARK: - lifecycle
    
    init() {
        super.init(frame: .zero)
        
        
        
        addSubview(groupStackView)
        groupStackView.bindToSuperview()
        
        addSubview(scrollView)
        scrollView.addSubview(transparentView)
        scrollView.bindToSuperview()
        transparentView.bindToSuperview()
        transparentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard
            let minGroupView = rows.filter({ $0.contentSize.width > bounds.width }).min(by: { $0.contentSize.width < $1.contentSize.width })
        else { return }
        
        minRowWidth = minGroupView.contentSize.width
        minRowOffset = minRowWidth - bounds.width
        transparentView.widthAnchor.constraint(equalToConstant: minRowWidth).isActive = true
    }

    //MARK: - helpers
    
    func setup(with group: TagGroup) {
        group.tags.forEach { interests in
            let stackView = UIStackView()
            stackView.spacing = 8
            stackView.axis = .horizontal
            
            interests.forEach { tag in
                let view = TagView()
                view.setup(following: tag.isFollowing, title: tag.tag)
                stackView.addArrangedSubview(view)
            }
            
            let scrollView = UIScrollView()
            scrollView.addSubview(stackView)
            scrollView.isUserInteractionEnabled = false
            stackView.bindToSuperview()
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
            
            rows.append(scrollView)
            groupStackView.addArrangedSubview(scrollView)
        }
        
        layoutIfNeeded()
    }
}

extension TagGroupView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView.contentOffset.x {
        case let x where x < 0:
            for row in rows {
                row.contentOffset.x = scrollView.contentOffset.x
            }
        case let x where x > minRowOffset:
            let minRowVisibleWidth = minRowWidth - scrollView.contentOffset.x
            
            for row in rows {
                let velocity = row.contentSize.width > bounds.width ?
                (row.contentSize.width - bounds.width) / minRowOffset : 1
                let offset = scrollView.contentOffset.x * velocity
                let currentRowVisibleWidth = row.contentSize.width - offset
                let overtakenDistance = minRowVisibleWidth - currentRowVisibleWidth
                row.contentOffset.x = offset - overtakenDistance
            }
        default:
            for row in rows {
                let velocity = row.contentSize.width > bounds.width ?
                (row.contentSize.width - bounds.width) / minRowOffset : 1
                let offset = scrollView.contentOffset.x * velocity
                row.contentOffset.x = offset
            }
        }
    }
}
