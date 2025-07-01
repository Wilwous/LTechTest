//
//  AuthWorker.swift
//  LTechTest
//
//  Created by Антон Павлов on 01.07.2025.
//

import Foundation
import Alamofire

// MARK: - Protocol

protocol AuthWorkerLogic {
    func fetchPhoneMask(completion: @escaping (Result<String, Error>) -> Void)
    func login(phone: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

// MARK: - DTO

private struct PhoneMaskResponse: Decodable {
    let phoneMask: String
}

private struct LoginResponse: Decodable {
    let success: Bool
}

final class AuthWorker: AuthWorkerLogic {
    
    // MARK: - Endpoints
    
    private let phoneMaskURL = "http://dev-exam.l-tech.ru/api/v1/phone_masks"
    private let loginURL = "http://dev-exam.l-tech.ru/api/v1/auth"
    
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
    
    func login(phone: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        print("📡 [AuthWorker] Logging in with phone: \(phone)")

        let plainPhone = phone.filter { $0.isNumber }
        let parameters: [String: String] = [
            "phone": plainPhone,
            "password": password
        ]
        
        AF.request(
            loginURL,
            method: .post,
            parameters: parameters,
            encoder: URLEncodedFormParameterEncoder.default
        )
        .validate()
        .responseDecodable(of: LoginResponse.self) { response in
            switch response.result {
            case .success(let result):
                print("✅ [AuthWorker] Login response: \(result.success)")
                completion(.success(result.success))
            case .failure(let error):
                print("❌ [AuthWorker] Login failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
