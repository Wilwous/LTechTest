//
//  AuthViewController.swift
//  LTechTest
//
//  Created by Антон Павлов on 26.06.2025.
//

import UIKit
import SnapKit

// MARK: - Protocol

protocol AuthDisplayLogic: AnyObject {
    func displayPhoneMask(viewModel: Auth.LoadPhoneMask.ViewModel)
    func displayLoginResult(viewModel: Auth.Login.ViewModel)
}

final class AuthViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var interactor: AuthBusinessLogic?
    private var presenter: AuthPresentationLogic?
    private var router: AuthRoutingLogic?
    private var signInButtonBottomConstraint: Constraint?
    private var keyboardHandler: KeyboardHandler?
    
    // MARK: - UI Elements
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Вход в аккаунт"
        label.textColor = .lBlack
        label.font = .boldSystemFont(ofSize: 24)
        
        return label
    }()
    
    private lazy var phoneInput: FormFieldView = {
        let field = FormFieldView(
            labelText: "Телефон",
            placeholder: "",
            isSecure: false,
            isPhone: true
        )
        field.onClearTapped = {
            field.textField.text = "+7 "
        }
        
        field.onTextChanged = { [weak self] in
            self?.updateSignInButtonState()
        }
        
        return field
    }()
    
    private lazy var passwordInput = FormFieldView(
        labelText: "Пароль",
        placeholder: "Введите пароль",
        isSecure: true
    )
    
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .lBlueDisabled
        button.setTitleColor(.lWhite, for: .normal)
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.addTarget(
            self,
            action: #selector(signInTapped),
            for: .touchUpInside
        )
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lWhite
        addElements()
        setupConstraints()
        setupTextFieldObservers()
        setupTapGesture()
        setupCleanSwift()
        autofillCredentials()
        keyboardHandler = KeyboardHandler(
            view: view,
            constraint: signInButtonBottomConstraint
        )
    }
    
    // MARK: - Setup View
    
    private func addElements() {
        [logoImageView,
         titleLabel,
         phoneInput,
         passwordInput,
         signInButton
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(56)
            make.centerX.equalToSuperview()
            make.height.equalTo(28)
            make.width.equalTo(131)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        phoneInput.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        passwordInput.snp.makeConstraints { make in
            make.top.equalTo(phoneInput.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        signInButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(50)
            signInButtonBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16).constraint
        }
    }
    
    private func setupCleanSwift() {
        let interactor = AuthInteractor()
        let presenter = AuthPresenter()
        let router = AuthRouter()
        
        self.interactor = interactor
        self.presenter = presenter
        self.router = router
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
    }
    
    // MARK: - Observers
    
    private func setupTextFieldObservers() {
        phoneInput.textField.addTarget(
            self,
            action: #selector(updateSignInButtonState),
            for: .editingChanged
        )
        
        passwordInput.textField.addTarget(
            self,
            action: #selector(updateSignInButtonState),
            for: .editingChanged
        )
    }
    
    private func showLoginError() {
        passwordInput.setError("Неверный пароль")
    }
    
    // MARK: - Keychain
    
    private func autofillCredentials() {
        if let phone = KeychainService.load(for: KeychainKeys.phone),
           let password = KeychainService.load(for: KeychainKeys.password) {
            phoneInput.textField.text = phone
            passwordInput.textField.text = password
            updateSignInButtonState()
        }
    }
    
    @objc private func signInTapped() {
        let phone = phoneInput.textField.text ?? ""
        let password = passwordInput.textField.text ?? ""
        
        let request = Auth.Login.Request(phone: phone, password: password)
        interactor?.login(request: request)
    }
    
    @objc private func updateSignInButtonState() {
        let phone = phoneInput.textField.text ?? ""
        let password = passwordInput.textField.text ?? ""
        
        let isPhoneValid = phone.count >= 18
        let isPasswordValid = !password.isEmpty
        let isFormValid = isPhoneValid && isPasswordValid
        
        if signInButton.isEnabled != isFormValid {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
        
        signInButton.isEnabled = isFormValid
        signInButton.backgroundColor = isFormValid ? .lBlue : .lBlueDisabled
    }
    
    // MARK: - Dismiss Keyboard
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - AuthDisplayLogic

extension AuthViewController: AuthDisplayLogic {
    func displayPhoneMask(viewModel: Auth.LoadPhoneMask.ViewModel) {
        phoneInput.applyMask(viewModel.formattedMask)
    }
    
    func displayLoginResult(viewModel: Auth.Login.ViewModel) {
        if viewModel.isSuccess {
            let phone = phoneInput.textField.text ?? ""
            let password = passwordInput.textField.text ?? ""
            KeychainService.save(phone, for: KeychainKeys.phone)
            KeychainService.save(password, for: KeychainKeys.password)
            
            router?.routeToDevExam()
        } else {
            showLoginError()
        }
    }
}
