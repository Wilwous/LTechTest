//
//  AuthWorker.swift
//  LTechTest
//
//  Created by Антон Павлов on 01.07.2025.
//

import Foundation
import Alamofire

protocol AuthWorkerLogic {
    func fetchPhoneMask(completion: @escaping (Result<String, Error>) -> Void)
}

// MARK: - DTO

private struct PhoneMaskResponse: Decodable {
    let phoneMask: String
}

final class AuthWorker: AuthWorkerLogic {
    
    // MARK: - Endpoints
    
     private let phoneMaskURL = "http://dev-exam.l-tech.ru/api/v1/phone_masks"
    
    // MARK: - Networking
    
    func fetchPhoneMask(completion: @escaping (Result<String, Error>) -> Void) {
        print("📡 [AuthWorker] Sending request to: \(phoneMaskURL)")
        
        AF.request(phoneMaskURL, method: .get)
            .validate()
            .responseDecodable(of: PhoneMaskResponse.self) { response in
                switch response.result {
                case .success(let decoded):
                    print("✅ [AuthWorker] Mask received: \(decoded.phoneMask)")
                    completion(.success(decoded.phoneMask))
                case .failure(let error):
                    print("❌ [AuthWorker] Failed to load mask: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
}
