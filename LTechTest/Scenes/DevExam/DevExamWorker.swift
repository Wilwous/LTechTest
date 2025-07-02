//
//  DevExamWorker.swift
//  LTechTest
//
//  Created by Антон Павлов on 02.07.2025.
//

import Foundation
import Alamofire

// MARK: - Protocol

protocol DevExamWorkerLogic {
    func fetchPosts(completion: @escaping (Result<[DevExam.Post], Error>) -> Void)
}

final class DevExamWorker: DevExamWorkerLogic {
    
    // MARK: - Endpoint
    
    private let postsURL = "http://dev-exam.l-tech.ru/api/v1/posts"
    
    // MARK: - Networking
    
    func fetchPosts(completion: @escaping (Result<[DevExam.Post], Error>) -> Void) {
        print("📡 [DevExamWorker] Fetching posts from: \(postsURL)")
        
        AF.request(postsURL, method: .get)
            .validate()
            .responseDecodable(of: [DevExam.Post].self) { response in
                if let data = response.data,
                   let raw = String(data: data, encoding: .utf8) {
                    print("🧾 Raw JSON:\n\(raw)")
                }
                
                switch response.result {
                case .success(let posts):
                    print("✅ [DevExamWorker] Posts fetched: \(posts.count)")
                    completion(.success(posts))
                case .failure(let error):
                    print("❌ [DevExamWorker] Failed to fetch posts: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
}
