//
//  DevExamModels.swift
//  LTechTest
//
//  Created by Антон Павлов on 02.07.2025.
//

import Foundation

enum DevExam {

    // MARK: - Use Cases

    enum LoadPosts {
        struct Request { }

        struct Response {
            let posts: [Post]
        }

        struct ViewModel {
            let items: [PostViewModel]
        }
    }

    enum SortOption: String, CaseIterable {
        case `default` = "По умолчанию"
        case byDate = "По дате"
    }

    // MARK: - Entity

    struct Post: Decodable {
        let id: String
        let title: String
        let text: String
        let image: String
        let sort: Int
        let date: String
    }

    struct PostViewModel {
        let title: String
        let subtitle: String
        let imageURL: URL?
        let dateString: String
        let originalDate: Date
    }
}
