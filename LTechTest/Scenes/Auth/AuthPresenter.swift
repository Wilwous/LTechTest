//
//  AuthPresenter.swift
//  LTechTest
//
//  Created by Антон Павлов on 01.07.2025.
//

import Foundation

protocol AuthPresentationLogic {
    func presentPhoneMask(response: Auth.LoadPhoneMask.Response)
}

final class AuthPresenter: AuthPresentationLogic {
    
    // MARK: - Weak Reference
    
    weak var viewController: AuthDisplayLogic?
    
    // MARK: - Use Cases
    
    func presentPhoneMask(response: Auth.LoadPhoneMask.Response) {
        let viewModel = Auth.LoadPhoneMask.ViewModel(formattedMask: response.mask)
        viewController?.displayPhoneMask(viewModel: viewModel)
    }
}
