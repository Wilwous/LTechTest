//
//  DevExamInteractor.swift
//  LTechTest
//
//  Created by Антон Павлов on 02.07.2025.
//

import Foundation

// MARK: - Protocol

protocol DevExamBusinessLogic {
    func loadPosts(request: DevExam.LoadPosts.Request)
}

final class DevExamInteractor: DevExamBusinessLogic {
    
    // MARK: - Dependencies
    
    var presenter: DevExamPresentationLogic?
    var worker: DevExamWorkerLogic = DevExamWorker()
    
    // MARK: - Use Case
    
    func loadPosts(request: DevExam.LoadPosts.Request) {
        worker.fetchPosts { [weak self] result in
            switch result {
            case .success(let posts):
                let response = DevExam.LoadPosts.Response(posts: posts)
                self?.presenter?.presentPosts(response: response)
            case .failure:
                let fallback = DevExam.LoadPosts.Response(posts: [])
                self?.presenter?.presentPosts(response: fallback)
            }
        }
    }
}
