//
//  ViewController.swift
//  janet.talks
//
//  Created by Coding on 10/3/21.
//

import UIKit

class HomeFeedViewController: UITableViewController {
    
    //MARK: - properties
    
    private let askQuestionButton: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "plus.circle")
        iv.tintColor = .label
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    //MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNav()
        tableView.backgroundColor = .systemBackground
        configure()
    }
    
    //MARK: - actions
    
    @objc private func askQuestionTapped(){
        
        let vc = AskAQuestionViewController()
        addChild(vc)
        vc.delegate = self
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        let frame: CGRect = CGRect(x: 0, y: 0 - tableView.height, width: tableView.width, height: tableView.height)
        vc.view.frame = frame
        tableView.isScrollEnabled = false
        UIView.animate(withDuration: 0.2) { [weak self] in
            vc.view.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            self?.askQuestionButton.isUserInteractionEnabled = false
            self?.askQuestionButton.alpha = 0.5
            
        }

    }
    
    //MARK: - helpers
    
    private func configureNav(){
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(askQuestionButton)
        askQuestionButton.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        askQuestionButton.clipsToBounds = true
        askQuestionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            askQuestionButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                                     constant: -Const.ImageRightMargin),
            askQuestionButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                                      constant: -Const.ImageBottomMarginForLargeState),
            askQuestionButton.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            askQuestionButton.widthAnchor.constraint(equalTo: askQuestionButton.heightAnchor)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(askQuestionTapped))
        tap.numberOfTapsRequired = 1
        askQuestionButton.addGestureRecognizer(tap)
        
    }
    
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()

        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState

        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()

        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0

        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()

        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)

        askQuestionButton.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    func configure(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.backgroundColor = .systemBackground
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "section: \(section + 1)"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

}

//MARK: - AskAQuestionDelegate

extension HomeFeedViewController: AskAQuestionDelegate {
    
    func closeAskAQuestion(_ vc: AskAQuestionViewController) {
        print("debug: being tapped")
        let frame: CGRect = vc.view.frame
        vc.view.frame = frame
        UIView.animate(withDuration: 0.5) {
            vc.view.frame = CGRect(x: 0, y: 0 + self.tableView.height, width: self.tableView.width, height: self.tableView.height)
        } completion: { [weak self] done in
            if done {
                self?.askQuestionButton.alpha = 1
                self?.askQuestionButton.isUserInteractionEnabled = true
                self?.tableView.isScrollEnabled = true
            }
        }
    }
    
}
