//
//  KeyboardHandler.swift
//  LTechTest
//
//  Created by Антон Павлов on 30.06.2025.
//

import UIKit
import SnapKit

final class KeyboardHandler {
    
    // MARK: - Private Properties
    
    private weak var view: UIView?
    private weak var constraint: Constraint?
    
    // MARK: - Init
    
    init(view: UIView, constraint: Constraint?) {
        self.view = view
        self.constraint = constraint
        addObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Observers
    
    private func addObservers() {
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(keyboardWillShow),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - Actions
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard
            let view = view,
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        constraint?.update(inset: keyboardFrame.height + 16)
        
        UIView.animate(withDuration: 0.25) {
            view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        constraint?.update(inset: 16)
        
        UIView.animate(withDuration: 0.25) {
            self.view?.layoutIfNeeded()
        }
    }
}
