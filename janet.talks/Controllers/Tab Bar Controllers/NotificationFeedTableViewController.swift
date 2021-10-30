//
//  ViewController.swift
//  janet.talks
//
//  Created by Coding on 10/3/21.
//

import UIKit

class NotificationFeedTableViewController: UITableViewController {
    
    //MARK: - properties
    
    private var feedItems = [HomeFeedCell]()
    
    private var activitySpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.color = .systemYellow
        spinner.style = .large
        return spinner
    }()
    
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
        view.addSubview(activitySpinner)
        activitySpinner.startAnimating()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        activitySpinner.center(inView:  view)
        
    }
    
    //MARK: - actions
    
    @objc private func askQuestionTapped(){
        
         let vc = AskAQuestionViewController()
         
         let navVC = UINavigationController(rootViewController: vc)
         navVC.navigationBar.prefersLargeTitles = true
         navVC.modalPresentationStyle = .fullScreen
         navVC.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
         present(navVC, animated: true, completion: nil)
         
    }
    
    //MARK: - helpers
    
    private func configureNav(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(askQuestionTapped))
        navigationItem.rightBarButtonItem?.tintColor = .label
        
    }
   
    func configure(){
        
        activitySpinner.stopAnimating()
        
        tableView.register(MyQuestionsTableViewCell.self, forCellReuseIdentifier: MyQuestionsTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyQuestionsTableViewCell.identifier) as! MyQuestionsTableViewCell
        cell.configureForPrivateChat()
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
        return 25
    }

}

//MARK: - AskAQuestionDelegate

extension NotificationFeedTableViewController: AskAQuestionDelegate {
    
    func closeAskAQuestion(_ vc: AskAQuestionViewController) {
        let frame: CGRect = vc.view.frame
        vc.view.frame = frame
        UIView.animate(withDuration: 0.5) {
            vc.view.frame = CGRect(x: 0, y: 0 + self.tableView.height, width: self.tableView.width, height: self.tableView.height)
                self.askQuestionButton.alpha = 1
        } completion: { [weak self] done in
            if done {
                vc.view.removeFromSuperview()
                vc.removeFromParent()
                
                self?.askQuestionButton.isUserInteractionEnabled = true
                self?.tableView.isScrollEnabled = true

            }
        }
    }
    
}
