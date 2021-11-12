//
//  AskQuestionSetImageAndTitleViewController.swift
//  janet.talks
//
//  Created by Coding on 10/25/21.
//

import UIKit

protocol AskQuestionSetImageAndTitleViewControllerDelegate: AnyObject {
    func addImageAndTitle(image: UIImage, title: String, usingDefaultImage: Bool, defaultImageName: String)
}

class AskQuestionSetImageAndTitleViewController: UIViewController {

    //MARK: - properties
    
    weak var delegate: AskQuestionSetImageAndTitleViewControllerDelegate?
    
    private let question: PublicQuestionToAdd
    private var featuredImageName = String()
    private var usingDefaultImage: Bool = true
    
    private let featuredImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 25
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let changePhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Featured Image", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.addTarget(self, action: #selector(changeImageTapped), for: .touchUpInside)
        return button
    }()
    
    private let titleTextField = TextInputWithTitle(title: "Title:", titleSize: 20, textFieldTextSize: 28)
    
    //MARK: - lifecycle
    
    init(_ question: PublicQuestionToAdd){
        self.question = question
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.textField.becomeFirstResponder()
        title = "Featured Image & Title"
        view.backgroundColor = .secondarySystemBackground
        
        configureTextView()
        configureNavigation()
        addSubviews()
        configureImage()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        featuredImageView.setDimensions(height: (view.width / 3), width: (view.width / 3))
        featuredImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: view.spacing)
        
        changePhotoButton.centerX(inView: featuredImageView, topAnchor: featuredImageView.bottomAnchor, paddingTop: 0)
        
        titleTextField.frame = CGRect(x: view.spacing, y: changePhotoButton.bottom + view.spacing, width: view.width - (view.spacing * 2), height: 200)
    }
    
    //MARK: - actions
    
    @objc private func changeImageTapped(){
        let sheet = UIAlertController(title: "Change Featured Image", message: "Please select an option below.", preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Take A Photo", style: .default, handler: {  [weak self] _ in
            
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = self
                self?.present(picker, animated: true)
            }
            
        }))
        sheet.addAction(UIAlertAction(title: "Choose From Library", style: .default, handler: {  [weak self] _ in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self?.present(picker, animated: true)
            }
            
        }))
        sheet.addAction(UIAlertAction(title: "Random Image", style: .default, handler: { [weak self] _ in
            self?.chooseRandomPhoto()
        }))
        
        present(sheet, animated: true)
    }
    
    @objc private func addImageAndTitle(){
        
        guard let image = featuredImageView.image, let title = titleTextField.textField.text else {
            return
        }
        
        if title.trimmingCharacters(in: .whitespaces).isEmpty {
            return
        } else if title.trimmingCharacters(in: .whitespaces).count < 3 {
            return
        }
        
        navigationController?.popViewController(animated: true)
        delegate?.addImageAndTitle(image: image, title: title, usingDefaultImage: usingDefaultImage, defaultImageName: featuredImageName)
        
    }
    
    //MARK: - helpers
    
    private func chooseRandomPhoto(){
        let randomNumber = Int.random(in: 1...26)
        
        self.featuredImageName = "feature\(randomNumber)"
        
        featuredImageView.image = UIImage(named: "feature\(randomNumber)")
    }
    
    private func configureTextView(){
        
        titleTextField.textField.delegate = self
        titleTextField.textField.autocapitalizationType = .words
        
        titleTextField.textField.text = question.title

    }
    
    private func configureNavigation(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(addImageAndTitle))
    }
    
    private func addSubviews(){
        view.addSubview(featuredImageView)
        view.addSubview(changePhotoButton)
        view.addSubview(titleTextField)
    }
    
    private func configureImage(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeImageTapped))
        featuredImageView.isUserInteractionEnabled = true
        featuredImageView.addGestureRecognizer(tap)
        
        if let image = question.featuredImage {
            featuredImageView.image = image
        } else {
            let randomNumber = Int.random(in: 1...26)
            
            self.featuredImageName = "feature\(randomNumber)"
            
            featuredImageView.image = UIImage(named: "feature\(randomNumber)")
            
        }
        
    }

}

//MARK: - uitextFieldDelegate

extension AskQuestionSetImageAndTitleViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            titleTextField.textField.resignFirstResponder()
        }
        
        return true
    }
}

//MARK: - uiimagepickerdelegate

extension AskQuestionSetImageAndTitleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        featuredImageView.image = image
        self.usingDefaultImage = false
    }
}
