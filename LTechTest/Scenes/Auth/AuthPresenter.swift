//
//  AuthPresenter.swift
//  LTechTest
//
//  Created by Антон Павлов on 01.07.2025.
//

import Foundation

// MARK: - Protocol

protocol AuthPresentationLogic {
    func presentPhoneMask(response: Auth.LoadPhoneMask.Response)
    func presentLoginResult(response: Auth.Login.Response)
}

final class AuthPresenter: AuthPresentationLogic {
    
    // MARK: - Weak Reference
    
    weak var viewController: AuthDisplayLogic?
    
    // MARK: - Use Cases
    
    func presentPhoneMask(response: Auth.LoadPhoneMask.Response) {
        let viewModel = Auth.LoadPhoneMask.ViewModel(formattedMask: response.mask)
        viewController?.displayPhoneMask(viewModel: viewModel)
    }
    
    func presentLoginResult(response: Auth.Login.Response) {
        let viewModel = Auth.Login.ViewModel(isSuccess: response.success)
        viewController?.displayLoginResult(viewModel: viewModel)
    }
}
