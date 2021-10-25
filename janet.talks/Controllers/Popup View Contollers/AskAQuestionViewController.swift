//
//  AskAQuestionViewController.swift
//  janet.talks
//
//  Created by Coding on 10/4/21.
//

import UIKit

protocol AskAQuestionDelegate: AnyObject{
    func closeAskAQuestion(_ vc: AskAQuestionViewController)
}

class AskAQuestionViewController: UIViewController {
    
    //MARK: - properties
    
    var cellSize = CGFloat()
    
    let questionTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemBackground
        tv.layer.cornerRadius = 25
        tv.isScrollEnabled = false
        return tv
    }()

    //MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNav()
        configureTableView()
        view.backgroundColor = .secondarySystemBackground
        title = "Ask A Question"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        questionTableView.center(inView: view)
        questionTableView.anchor(width: view.width - (view.spacing * 2), height: view.width - (view.spacing * 2))
    }
    
    //MARK: - actions
    
    @objc private func didTapClose(){
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - helpers
    
    private func configureTableView(){
        
        self.cellSize = ((view.width) - (view.spacing * 2)) / 4
        
        questionTableView.register(AskAQuestionTableViewCell.self, forCellReuseIdentifier: AskAQuestionTableViewCell.identifier)
        
        questionTableView.delegate = self
        questionTableView.dataSource = self
        
        view.addSubview(questionTableView)
    }
    
    private func configureNav(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapClose))
        
    }
    
    private func configureButtons(){
//        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }
    
}

//MARK: - uitableview Delegate & Datasource
extension AskAQuestionViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = questionTableView.dequeueReusableCell(withIdentifier: AskAQuestionTableViewCell.identifier, for: indexPath) as! AskAQuestionTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.configure(cellTitle: "Image & Title")
        case 1:
            cell.configure(cellTitle: "Question")
        case 2:
            cell.configure(cellTitle: "Situation/Background")
        case 3:
            cell.configure(cellTitle: "Tags & Images")
        default:
            fatalError()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellSize
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
}
