//
//  MainTabBarController.swift
//  LTechTest
//
//  Created by Антон Павлов on 02.07.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {

    // MARK: - UI Elements

    private lazy var mainViewController: UIViewController = {
        let vc = DevExamViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(
            title: "Главная",
            image: UIImage(named: "icon_home"),
            selectedImage: UIImage(named: "icon_home")
        )
        return nav
    }()

    private lazy var favoritesViewController: UIViewController = {
        let vc = PlaceholderViewController(title: "Избранное")
        vc.tabBarItem = UITabBarItem(
            title: "Избранное",
            image: UIImage(named: "icon_heart"),
            selectedImage: UIImage(named: "icon_heart")
        )
        
        return UINavigationController(rootViewController: vc)
    }()

    private lazy var profileViewController: UIViewController = {
        let vc = PlaceholderViewController(title: "Аккаунт")
        vc.tabBarItem = UITabBarItem(
            title: "Аккаунт",
            image: UIImage(named: "icon_user"),
            selectedImage: UIImage(named: "icon_user")
        )
        
        return UINavigationController(rootViewController: vc)
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        addControllers()
    }

    // MARK: - Setup

    private func setupTabBar() {
        tabBar.backgroundColor = .lWhite
        tabBar.tintColor = .lBlue
        tabBar.unselectedItemTintColor = .lGray
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.systemGray4.cgColor
        tabBar.clipsToBounds = true
    }

    private func addControllers() {
        viewControllers = [
            mainViewController,
            favoritesViewController,
            profileViewController
        ]
    }
}
