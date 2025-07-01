//
//  AuthModels.swift
//  LTechTest
//
//  Created by Антон Павлов on 01.07.2025.
//

import Foundation

enum Auth {
    
    // MARK: - Use Cases
    
    enum LoadPhoneMask {
        struct Request { }
        
        struct Response {
            let mask: String
        }
        
        struct ViewModel {
            let formattedMask: String
        }
    }
    
    enum Login {
        struct Request {
            let phone: String
            let password: String
        }
        
        struct Response {
            let success: Bool
        }
        
        struct ViewModel {
            let isSuccess: Bool
        }
    }
}
