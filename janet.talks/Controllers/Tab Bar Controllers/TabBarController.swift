//
//  TabBarController.swift
//  janet.talks
//
//  Created by Coding on 10/5/21.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    //MARK: - properties
    
    private var signinHasBeenPresented = false
    
    //MARK: - lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PersistenceManager.shared.setLanguage(language: .english)
        
//        UserManager.shared.signOut()
        DispatchQueue.main.async { [weak self] in
            
            if UserDefaults.standard.bool(forKey: "doesntHaveUserName") {
                let vc = UsernamePickerViewController(reason: .accountHasNoUsername, user: User(username: "", email: UserDefaults.standard.string(forKey: "email")!))
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
                vc.completion = {
                    vc.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        setUpControllers()
        
    }
    
    //MARK: - actions
    
    //MARK: - helpers
    
    private func setUpControllers(){
        
        let home = HomeViewController()
        let questionsChatsAndArticles = NotificationFeedTableViewController()
        let alerts = NotificationFeedTableViewController()
        let profile = ProfileViewController()
        
        home.title = "relationship.talks"
        questionsChatsAndArticles.title = "my questions"
        alerts.title = "alerts"
        profile.title = "profile"
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: questionsChatsAndArticles)
        let nav3 = UINavigationController(rootViewController: alerts)
        let nav4 = UINavigationController(rootViewController: profile)
        
        
        
        nav1.navigationItem.rightBarButtonItem?.tintColor = .label
        nav1.navigationItem.leftBarButtonItem?.tintColor = .label
        
        nav2.navigationItem.rightBarButtonItem?.tintColor = .label
        nav2.navigationItem.leftBarButtonItem?.tintColor = .label
        
        nav3.navigationItem.rightBarButtonItem?.tintColor = .label
        nav3.navigationItem.leftBarButtonItem?.tintColor = .label
        
        nav4.navigationItem.rightBarButtonItem?.tintColor = .label
        nav4.navigationItem.leftBarButtonItem?.tintColor = .label
        
        nav1.tabBarItem = UITabBarItem(title: "Q Feed", image: UIImage(systemName: "square.text.square.fill"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "My Qs", image: UIImage(systemName: "questionmark.app.fill"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Alerts", image: UIImage(systemName: "bell.fill"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 4)
        
        UITabBar.appearance().tintColor = .label
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        nav4.navigationBar.prefersLargeTitles = true
        
        nav1.navigationBar.shadowImage = UIImage()
        
        tabBar.backgroundColor = .systemBackground
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
        
    }
}
