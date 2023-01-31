//
//  LoginPageViewModel.swift
//  VibrationWizard
//
//  Created by Consultant on 1/30/23.
//

import Foundation
import Combine
import UIKit
import FirebaseAuth

class LoginPageVM
{
    let myFirebaseAPI = FirebaseAPI()
    var subs = Set<AnyCancellable>()
    
    var email = CurrentValueSubject<String, Never>("")
    var password = CurrentValueSubject<String, Never>("")
    var valid = CurrentValueSubject<Bool, Never>(false)
    
    init()
    {
        setupLogin()
    }
    
    func setupLogin()
    {
        email
            .dropFirst(1)
            .combineLatest(password.dropFirst(1))
            .map { (inputEmail, inputPassword) -> AnyPublisher<Bool, Never> in
                print("\(inputEmail) \(inputPassword)")
                return self.myFirebaseAPI.login(email: inputEmail, password: inputPassword)
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .sink { status in
                self.valid.send(status)
            }
            .store(in: &subs)
    }
}
