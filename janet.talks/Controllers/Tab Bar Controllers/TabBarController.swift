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
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - actions
    
    //MARK: - helpers
    
    private func presentSignInIfNeeded(){
        //present the signin screen if user is not logged in
        DispatchQueue.main.async {
            
        }
        
    }
    
    private func setUpControllers(){
        
        let home = NotificationFeedTableViewController()
        let explore = ExploreFeedViewController()
        let profile = ProfileViewController()
        
        home.title = "janet.talks"
        explore.title = "explore"
        profile.title = "profile"
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: explore)
        let nav3 = UINavigationController(rootViewController: profile)
        
        nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bubble.left.and.bubble.right.fill"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "square.text.square.fill"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.crop.circle"), tag: 3)
        
        UITabBar.appearance().tintColor = .label

        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        
        tabBar.backgroundColor = .systemBackground
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        setViewControllers([nav1, nav2, nav3], animated: true)
    }
}
