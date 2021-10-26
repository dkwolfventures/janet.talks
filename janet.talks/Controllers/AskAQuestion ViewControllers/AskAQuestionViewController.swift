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
    
    var viewModels = [AddAQuestionCellType]()
    private var questionToPost = PublicQuestionToAdd(featuredImage: nil, title: nil, question: nil, situationOrBackground: nil, tags: nil, questionImages: nil)
    
    private var imageAndTitle = ImageAndTitleTableViewCellViewModel(title: "Image & Title", isComplete: false)
    private var question = QuestionTableViewCellViewModel(title: "Question", isComplete: false)
    private var situationOrBackground = SituationOrBackgroundTableViewCellViewModel(title: "Background Info", isComplete: false)
    private var tagsAndImages = TagsAndImagesTableViewCellViewModel(title: "Tags & Images", isComplete: false)

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
    
    @objc private func previewQTapped(){
        
    }
    
    //MARK: - helpers
    
    private func configureTableView(){
        
        self.viewModels = [ .ImageAndTitle(viewModel: imageAndTitle) , .Question(viewModel: question), .SituationOrBackground(viewModel: situationOrBackground), .TagsAndImages(viewModel: tagsAndImages)]
        
        self.cellSize = ((view.width) - (view.spacing * 2)) / 4
        
        questionTableView.register(ImageAndTitleTableViewCell.self, forCellReuseIdentifier: ImageAndTitleTableViewCell.identifier)
        
        questionTableView.register(QuestionTableViewCell.self, forCellReuseIdentifier: QuestionTableViewCell.identifier)
        
        questionTableView.register(SituationOrBackgroundTableViewCell.self, forCellReuseIdentifier: SituationOrBackgroundTableViewCell.identifier)
        
        questionTableView.register(TagsAndImagesTableViewCell.self, forCellReuseIdentifier: TagsAndImagesTableViewCell.identifier)
        
        questionTableView.delegate = self
        questionTableView.dataSource = self
        
        view.addSubview(questionTableView)
    }
    
    private func configureNav(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapClose))
        
        if self.question.isComplete && self.imageAndTitle.isComplete {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Preview Q", style: .done, target: self, action: #selector(previewQTapped))
        }
        
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
        
        let cellType = viewModels[indexPath.row]
        
        switch cellType {
        case .ImageAndTitle(let viewModel):
            let cell = questionTableView.dequeueReusableCell(withIdentifier: ImageAndTitleTableViewCell.identifier, for: indexPath) as! ImageAndTitleTableViewCell
            
            cell.configure(row: indexPath.row, viewModel: viewModel)
            
            return cell
        case .Question(let viewModel):
            let cell = questionTableView.dequeueReusableCell(withIdentifier: QuestionTableViewCell.identifier, for: indexPath) as! QuestionTableViewCell
            cell.configure(row: indexPath.row, viewModel: viewModel)
            return cell
        case .SituationOrBackground(let viewModel):
            let cell = questionTableView.dequeueReusableCell(withIdentifier: SituationOrBackgroundTableViewCell.identifier, for: indexPath) as! SituationOrBackgroundTableViewCell
            cell.configure(row: indexPath.row, viewModel: viewModel)
            return cell
        case .TagsAndImages(let viewModel):
            let cell = questionTableView.dequeueReusableCell(withIdentifier: TagsAndImagesTableViewCell.identifier, for: indexPath) as! TagsAndImagesTableViewCell
            cell.configure(row: indexPath.row, viewModel: viewModel)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellSize
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        questionTableView.deselectRow(at: indexPath, animated: true)
        
        let cell = viewModels[indexPath.row]
        
        switch cell {
        case .ImageAndTitle(_):
            let vc = AskQuestionSetImageAndTitleViewController(questionToPost)
            vc.delegate = self
            show(vc, sender: self)
        case .Question(_):
            let vc = AskQuestionCreateQuestionViewController(question: questionToPost)
            vc.delegate = self
            show(vc, sender: self)
        case .SituationOrBackground(_):
            let vc = AskQuestionSituationOrBackgroundViewController(question: questionToPost)
            vc.delegate = self
            show(vc, sender: self)
        case .TagsAndImages(_):
            self.tagsAndImages.isComplete = true
            configureTableView()
            questionTableView.reloadData()
        }
    }
}

//MARK: - AskQuestionSetImageAndTitleViewControllerDelegate

extension AskAQuestionViewController: AskQuestionSetImageAndTitleViewControllerDelegate{
    func addImageAndTitle(image: UIImage, title: String) {
        
        self.questionToPost.featuredImage = image
        self.questionToPost.title = title
        self.imageAndTitle.isComplete = true
        configureTableView()
        questionTableView.reloadData()
        
        configureNav()
                
        if questionToPost.question == nil {
            
            let vc = AskQuestionCreateQuestionViewController(question: questionToPost)
            vc.delegate = self
            show(vc, sender: self)
            
        }
        
    }
}

//MARK: -

extension AskAQuestionViewController: AskQuestionCreateQuestionViewControllerDelegate{
    func addQuestion(question: String) {
        
        self.questionToPost.question = question
        self.question.isComplete = true
        configureTableView()
        questionTableView.reloadData()
        
        configureNav()
        
        if questionToPost.situationOrBackground == nil {
            
            let vc = AskQuestionSituationOrBackgroundViewController(question: questionToPost)
            vc.delegate = self
            show(vc, sender: self)
        }
    }
}

//MARK: - Section Heading

extension AskAQuestionViewController: AskQuestionSituationOrBackgroundViewControllerDelegate{
    func addBackgroundInfo(background: String) {
        self.questionToPost.situationOrBackground = background
        self.situationOrBackground.isComplete = true
        configureTableView()
        questionTableView.reloadData()
    }
}
