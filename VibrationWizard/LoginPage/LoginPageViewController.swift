//
//  LoginPageViewController.swift
//  VibrationWizard
//
//  Created by Consultant on 1/30/23.
//

import UIKit
import Combine

class LoginPageViewController: UIViewController
{
    
    let vm = LoginPageVM()
    var subs = Set<AnyCancellable>()
    
    let emailTextField = EmailTextField(placeholder: "Email")
    let passwordTextField = PasswordTextField(placeholder: "Password")
    
    let loginBtn = LoginBtn()
    let createAccountBtn = CreateAccountBtn()
    let logoImageView = UIImageView()
    
    let statusLabel = StatusLabel()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemPurple
        configureLogoImageView()
        configureEmailTextField()
        configurePasswordTextField()
        configureLoginBtn()
        configureCreateAcccountBtn()
        configStatusLabel()
        
        //setupEmailAndPasswordListner()
        
        
        vm.valid
            .dropFirst(1)
            .sink {[unowned self] status in
            if !status
            {
                self.statusLabel.textColor = UIColor.red
                statusLabel.text = "Login failed, try again"
            } else {
                self.statusLabel.textColor = UIColor.green
                statusLabel.text = "Login Sucess"
            }
        }.store(in: &subs)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupEmailAndPasswordListner()
    {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification,
                                             object: emailTextField)
        .compactMap { notification in
            (notification.object as? UITextField)?.text
        }
        .sink { [weak self] inputEmail in
            self?.vm.email.send(inputEmail)
        }.store(in: &subs)
    }
    
    @objc
    func loginBtnClicked()
    {
        vm.email.send(emailTextField.text!)
        vm.password.send(passwordTextField.text!)
    }
    
    @objc
    func createAccountBtnClicked()
    {
        navigationController?.pushViewController(CreateAccountViewController(), animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: nil, action: nil)
    }
    
    func configStatusLabel()
    {
        view.addSubview(statusLabel)
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: createAccountBtn.bottomAnchor, constant: 10),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            statusLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configureCreateAcccountBtn()
    {
        view.addSubview(createAccountBtn)
        NSLayoutConstraint.activate([
            createAccountBtn.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 20),
            createAccountBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            createAccountBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            createAccountBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        createAccountBtn.addTarget(self, action: #selector(createAccountBtnClicked), for: .touchUpInside)
    }
    
    func configureLoginBtn()
    {
        view.addSubview(loginBtn)
        NSLayoutConstraint.activate([
            loginBtn.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            loginBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            loginBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            loginBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        loginBtn.addTarget(self, action: #selector(loginBtnClicked), for: .touchUpInside)
    }
    
    func configurePasswordTextField()
    {
        view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureEmailTextField()
    {
        view.addSubview(emailTextField)
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureLogoImageView()
    {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "wizard")!
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 300),
            logoImageView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    
}
