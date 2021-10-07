//
//  PublicQuestionTableViewController.swift
//  janet.talks
//
//  Created by Coding on 10/6/21.
//

import UIKit

class PublicQuestionTableViewController: UITableViewController {
    
    //MARK: - properties
    
    private var feedItems = [HomeFeedCell]()
    
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
        tableView.backgroundColor = .systemBackground
        configure()
    }
    
    //MARK: - actions
    
    //MARK: - helpers
    
    func configure(){
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
