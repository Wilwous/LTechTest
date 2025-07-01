//
//  AuthInteractor.swift
//  LTechTest
//
//  Created by Антон Павлов on 01.07.2025.
//

import Foundation

protocol AuthBusinessLogic {
    func loadPhoneMask(request: Auth.LoadPhoneMask.Request)
}

final class AuthInteractor: AuthBusinessLogic {
    
    // MARK: - Dependencies
    
    var presenter: AuthPresentationLogic?
    var worker: AuthWorkerLogic = AuthWorker()
    
    // MARK: - Use Cases
    
    func loadPhoneMask(request: Auth.LoadPhoneMask.Request) {
        worker.fetchPhoneMask { [weak self] result in
            switch result {
            case .success(let mask):
                let response = Auth.LoadPhoneMask.Response(mask: mask)
                self?.presenter?.presentPhoneMask(response: response)
            case .failure:
                let fallback = Auth.LoadPhoneMask.Response(mask: "+7 (###) ###-##-##")
                self?.presenter?.presentPhoneMask(response: fallback)
            }
        }
    }
}
