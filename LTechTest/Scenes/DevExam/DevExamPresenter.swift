//
//  DevExamPresenter.swift
//  LTechTest
//
//  Created by Антон Павлов on 02.07.2025.
//

import Foundation

// MARK: - Protocol

protocol DevExamPresentationLogic {
    func presentPosts(response: DevExam.LoadPosts.Response)
}

final class DevExamPresenter: DevExamPresentationLogic {
    
    // MARK: - Weak Reference
    
    weak var viewController: DevExamDisplayLogic?
    
    // MARK: - Use Case
    
    func presentPosts(response: DevExam.LoadPosts.Response) {
        let isoFormatter = ISO8601DateFormatter()

        let viewModels = response.posts.map {
            DevExam.PostViewModel(
                title: $0.title,
                subtitle: $0.text,
                imageURL: URL(string: $0.image),
                dateString: DateFormatterHelper.format(date: $0.date),
                originalDate: isoFormatter.date(from: $0.date) ?? .distantPast
            )
        }

        let viewModel = DevExam.LoadPosts.ViewModel(items: viewModels)
        viewController?.displayPosts(viewModel: viewModel)
    }
}
