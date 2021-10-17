//
//  SearchResultsViewController.swift
//  janet.talks
//
//  Created by Coding on 10/17/21.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    
}

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    public weak var delegate: SearchResultsViewControllerDelegate?

    private var questions = [PublicQuestion]()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
//    public func update(with results: [User]) {
//        self.users = results
//        tableView.reloadData()
//        tableView.isHidden = users.isEmpty
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = questions[indexPath.row].subject
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
