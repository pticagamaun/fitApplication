//
//  MainTabBarController.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 12.11.2022.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setTabBar()
    }
    private func configure() {
        tabBar.backgroundColor = .specialTabBar
        tabBar.tintColor = .specialDarkGreen
        tabBar.unselectedItemTintColor = .specialGray
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.specialLightBrown.cgColor
    }
    private func setTabBar() {
        let mainVC = MainViewController()
        let statisticVC = StatisticsViewController()
        let profileVC = ProfileViewController()
        setViewControllers([mainVC, statisticVC, profileVC], animated: true)
        guard let items = tabBar.items else {return}
        items[0].title = "Main"
        items[1].title = "Statistic"
        items[2].title = "Profile"
        items[0].image = UIImage(named: "mainTabBar")
        items[1].image = UIImage(named: "statisticTabBar")
        items[2].image = UIImage(named: "profile")
        UITabBarItem.appearance().setTitleTextAttributes([.font : UIFont(name: "Roboto-Bold", size: 12) as Any], for: .normal)
    }
}
