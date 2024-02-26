//
//  FormValidationUIKit.swift
//  CombineBootcamp
//
//  Created by macbook abdul on 26/02/2024.
//

import Foundation
import Combine
import UIKit

class LoginViewModel: ObservableObject {
    enum ViewState {
        case loading
        case success
        case failed
        case none
    }
    @Published var email = ""
    @Published var password = ""
    @Published var state: ViewState = .none
    let isTrueSubject = PassthroughSubject<Bool,Never>()

    
    var isValidUsernamePublisher: AnyPublisher<Bool, Never> {
        $email
            .map { $0.isValidEmail }
            .eraseToAnyPublisher()
    }

    var isValidPasswordPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    var isSubmitEnabled: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isValidUsernamePublisher, isValidPasswordPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }

    func submitLogin() {
        state = .loading
        // hardcoded 2 seconds delay, to simulate request
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
            guard let self = self else { return }
            if self.isCorrectLogin() {
                self.state = .success
            } else {
                self.state = .failed
            }
        }
    }
    
    
    func isCorrectLogin() -> Bool {
        // hardcoded example
        return email == "abdul@live.com" && password == "12345"
    }
}

extension String {
    var isValidEmail: Bool {
        return NSPredicate(
            format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        )
        .evaluate(with: self)
    }
}

class ViewController: UIViewController {
    var viewModel = LoginViewModel()
    var cancellables = Set<AnyCancellable>()
    // MARK: - UI
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.textContentType = .emailAddress
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter email.."
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter password.."
        textField.isSecureTextEntry = true
        return textField
    }()

    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Oops, incorrect email or password!"
        label.textColor = .white
        label.backgroundColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
        return button
    }()

    // MARK: - Common cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupPublishers()
    }

    func setupViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(submitButton)
        stackView.addArrangedSubview(errorLabel) // append the error label here
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            submitButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    func setupPublishers() {
        // update published variables once text changed for both text fields
//        NotificationCenter.default
//            .publisher(for: UITextField.textDidChangeNotification, object: emailTextField)
//            .map { ($0.object as! UITextField).text ?? "" }
//            .assign(to: \.email, on: viewModel)
//            .store(in: &cancellables)
        
        emailTextField.publisher(for: .allEditingEvents)
            .map({ [weak self]_ in
                self?.emailTextField.text ?? ""
            })
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
    
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: passwordTextField)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        //button binding
        submitButton.publisher(for: .touchUpInside)
            .sink(receiveValue: {  [weak self] value in
                       print("button is tapped \(value)")
                self?.viewModel.submitLogin()
                    })
                    .store(in: &cancellables)
        
        // subscribers
        viewModel.isSubmitEnabled
            .assign(to: \.isEnabled, on: submitButton)
            .store(in: &cancellables)

        viewModel.$state
            .sink { [weak self] state in
                switch state {
                case .loading:
                    self?.submitButton.isEnabled = false
                    self?.submitButton.setTitle("Loading..", for: .normal)
                    self?.hideError(true)
                case .success:
                   print("Result success")
                   
                    self?.resetButton()
                    self?.hideError(true)
                    self?.showHomeScreen()
                case .failed:
                    self?.resetButton()
                    self?.hideError(false)
                case .none:
                    break
                }
            }
            .store(in: &cancellables)
        
        
        //bar button
        
        
        //using passthrough subject
        let item1 = UIBarButtonItem(barButtonSystemItem: .add, cancellables: &cancellables) { [weak self] in
            self?.viewModel.isTrueSubject.send(true)
        }
        
        let item2 = UIBarButtonItem(barButtonSystemItem: .close, cancellables: &cancellables) { [weak self] in
            self?.viewModel.isTrueSubject.send(false)
        }
        
        self.viewModel.isTrueSubject.sink { isTrue in
            self.view.backgroundColor = isTrue ? .red : .white
        }.store(in: &cancellables)
//
        self.navigationItem.setRightBarButtonItems([item1], animated: true)
        self.navigationItem.setLeftBarButtonItems([item2], animated: true)
        
        
    }
    
    @objc func onSubmit() {
//        viewModel.submitLogin()
    }

    func resetButton() {
        submitButton.setTitle("Login", for: .normal)
        submitButton.isEnabled = true
    }
    func showHomeScreen() {
      self.navigationController?.pushViewController(UIViewController(), animated: true)
    }
    func hideError(_ isHidden: Bool) {
        errorLabel.alpha = isHidden ? 0 : 1
    }
}
#Preview {
    UINavigationController(rootViewController: ViewController())
}
