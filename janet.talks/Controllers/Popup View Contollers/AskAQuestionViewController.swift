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
    

    //MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        view.backgroundColor = .systemBackground
        title = "Ask A Question"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    //MARK: - actions
    
    @objc private func didTapClose(){
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - helpers
    
    private func configureNav(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapClose))
    }
    
    private func configureButtons(){
//        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }
    
}
