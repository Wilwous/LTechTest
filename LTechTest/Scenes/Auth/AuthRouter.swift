//
//  AuthRouter.swift
//  LTechTest
//
//  Created by Антон Павлов on 02.07.2025.
//

import UIKit

// MARK: - Protocol

protocol AuthRoutingLogic {
    func routeToDevExam()
}

final class AuthRouter: AuthRoutingLogic {
    
    // MARK: - Weak Reference
    
    weak var viewController: UIViewController?
    
    // MARK: - Public Methods
    
    func routeToDevExam() {
        let mainTabBar = MainTabBarController()

        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first else {
            return
        }

        window.rootViewController = mainTabBar

        UIView.transition(
            with: window,
            duration: 0.4,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
}
