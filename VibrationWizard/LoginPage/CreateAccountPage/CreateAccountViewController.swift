//
//  CreateAccountViewController.swift
//  VibrationWizard
//
//  Created by Consultant on 1/30/23.
//

import UIKit
import Combine

class CreateAccountViewController: UIViewController {
    
    let vm = CreateNewAccountVM()
    var subs = Set<AnyCancellable>()

    let emailTextField = EmailTextField(placeholder: "Email")
    let userTextField = EmailTextField(placeholder: "Username")
    let passwordTextField = PasswordTextField(placeholder: "Password")
    let passwordTextField2 = PasswordTextField(placeholder: "Re-type Password")
    let profileNameTextField = EmailTextField(placeholder: "Profile Name")
    let createAccountBtn = CreateNewAccountBtn()
    
    let titleFont = [
        NSAttributedString.Key.foregroundColor: UIColor.systemYellow,
        NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 24)!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        view.backgroundColor = .systemPurple
        title = "Create Account"
        navigationController?.navigationBar.titleTextAttributes = titleFont
        
        configEmailTextField()
        configUserTextField()
        configPasswordTextField()
        configPasswordTextField2()
        configProfileNameTextField()
        configCreateAccountBtn()
        
        vm.userCreatedStatus
            .sink { status in
                print("User account created: \(status)")
            }.store(in: &subs)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc
    func createAccountBtnClicked()
    {
        vm.email.send(emailTextField.text!)
        vm.password1.send(passwordTextField.text!)
        vm.username.send(userTextField.text!)
        vm.profileName.send(profileNameTextField.text!)
    }
    
    func configCreateAccountBtn()
    {
        view.addSubview(createAccountBtn)
        NSLayoutConstraint.activate([
            createAccountBtn.topAnchor.constraint(equalTo: profileNameTextField.bottomAnchor, constant: 40),
            createAccountBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            createAccountBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            createAccountBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        createAccountBtn.addTarget(self, action: #selector(createAccountBtnClicked), for: .touchUpInside)
    }
    
    func configProfileNameTextField()
    {
        view.addSubview(profileNameTextField)
        NSLayoutConstraint.activate([
            profileNameTextField.topAnchor.constraint(equalTo: passwordTextField2.bottomAnchor, constant: 40),
            profileNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            profileNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            profileNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configPasswordTextField2()
    {
        view.addSubview(passwordTextField2)
        NSLayoutConstraint.activate([
            passwordTextField2.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            passwordTextField2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            passwordTextField2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            passwordTextField2.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configPasswordTextField()
    {
        view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 40),
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configUserTextField()
    {
        view.addSubview(userTextField)
        NSLayoutConstraint.activate([
            userTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            userTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            userTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            userTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configEmailTextField()
    {
        view.addSubview(emailTextField)
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
