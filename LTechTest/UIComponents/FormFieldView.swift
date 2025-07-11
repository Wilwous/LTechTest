//
//  FormFieldView.swift
//  LTechTest
//
//  Created by Антон Павлов on 30.06.2025.
//

import UIKit
import SnapKit

final class FormFieldView: UIView {
    
    // MARK: - Closure
    
    var onClearTapped: (() -> Void)?
    var onTextChanged: (() -> Void)?
    
    // MARK: - Private Properties
    
    private var isSecureField = false
    private var isPhoneField = false
    
    // MARK: - UI Elements
    
    lazy var textField: UITextField = {
        let text = UITextField()
        text.borderStyle = .none
        text.backgroundColor = .white
        text.layer.cornerRadius = 14
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.lExtralightGray.cgColor
        text.delegate = self
        text.addTarget(
            self,
            action: #selector(handleTextChange),
            for: .editingChanged
        )
        
        return text
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .lBlack
        
        return label
    }()
    
    private lazy var eyeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "ic_eye_closed")
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.tintColor = .lightGray
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.addTarget(
            self,
            action: #selector(togglePasswordVisibility),
            for: .touchUpInside
        )
        
        return button
    }()
    
    private lazy var clearButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "ic_clear_input")
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let button = UIButton(configuration: config, primaryAction: nil)
        button.tintColor = .lightGray
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.addTarget(
            self,
            action: #selector(clearPhoneField),
            for: .touchUpInside
        )
        
        return button
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lRed
        label.numberOfLines = 0
        label.isHidden = true
        
        return label
    }()
    
    // MARK: - Init
    
    init(
        labelText: String,
        placeholder: String,
        isSecure: Bool = false,
        isPhone: Bool = false
    ) {
        super.init(frame: .zero)
        self.isSecureField = isSecure
        self.isPhoneField = isPhone
        titleLabel.text = labelText
        addElements()
        setupConstraints()
        configureTextField(placeholder: placeholder)
        setupTextFieldPadding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func applyMask(_ mask: String) {
        if isPhoneField {
            textField.text = "+7 "
        }
    }
    
    func setError(_ text: String?) {
        errorLabel.text = text
        errorLabel.isHidden = text == nil
        textField.layer.borderColor = text == nil ? UIColor.lExtralightGray.cgColor : UIColor.lRed.cgColor
    }
    
    // MARK: - Setup View
    
    private func addElements() {
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(errorLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
            make.bottom.equalTo(errorLabel.snp.top).offset(-4)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureTextField(placeholder: String) {
        if isSecureField {
            textField.isSecureTextEntry = true
            textField.placeholder = placeholder
            textField.rightView = eyeButton
        }
        
        if isPhoneField {
            textField.text = "+7 "
            textField.rightView = clearButton
            textField.keyboardType = .numberPad
        }
    }
    
    private func setupTextFieldPadding() {
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 48))
        textField.leftView = leftPadding
        textField.leftViewMode = .always
        textField.rightViewMode = .always
    }
    
    // MARK: - Actions
    
    @objc private func togglePasswordVisibility() {
        textField.isSecureTextEntry.toggle()
        let icon = textField.isSecureTextEntry ? "ic_eye_closed" : "ic_eye_open"
        eyeButton.setImage(UIImage(named: icon), for: .normal)
    }
    
    @objc private func clearPhoneField() {
        textField.text = "+7 "
        onClearTapped?()
        onTextChanged?()
    }
    
    @objc private func handleTextChange() {
        setError(nil)
        onTextChanged?()
    }
}

// MARK: - UITextFieldDelegate

extension FormFieldView: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard isPhoneField else { return true }
        
        let current = textField.text ?? ""
        
        if range.location < 3 {
            return false
        }
        
        guard let textRange = Range(range, in: current) else { return false }
        
        let updated = current.replacingCharacters(in: textRange, with: string)
        
        let digitsOnly = updated.filter { $0.isNumber }
        
        let digits = String(digitsOnly.dropFirst()).prefix(10)
        
        var result = "+7 "
        
        for (i, char) in digits.enumerated() {
            switch i {
            case 0:
                result += "(\(char)"
            case 2:
                result += "\(char)) "
            case 5, 7:
                result += "\(char)-"
            default:
                result += "\(char)"
            }
        }
        
        textField.text = result
        onTextChanged?()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.lBlack.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.lExtralightGray.cgColor
    }
}
