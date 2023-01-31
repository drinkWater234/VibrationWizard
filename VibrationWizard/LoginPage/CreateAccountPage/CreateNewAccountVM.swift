//
//  CreateNewAccountVM.swift
//  VibrationWizard
//
//  Created by Consultant on 1/30/23.
//

import Foundation
import Combine

class CreateNewAccountVM
{
    let myFirebaseAPI = FirebaseAPI()
    var subs = Set<AnyCancellable>()
    
    /*
    var email = CurrentValueSubject<String, Never>("")
    var username = CurrentValueSubject<String, Never>("")
    var password1 = CurrentValueSubject<String, Never>("")
    var password2 = CurrentValueSubject<String, Never>("")
    var profileName = CurrentValueSubject<String, Never>("")
    
    var emailExist = CurrentValueSubject<Bool, Never>(false)
    var userNameExist = CurrentValueSubject<Bool, Never>(false)
     */
    
    var email = PassthroughSubject<String, Never>()
    var username = PassthroughSubject<String, Never>()
    var password1 = PassthroughSubject<String, Never>()
    var password2 = PassthroughSubject<String, Never>()
    var profileName = PassthroughSubject<String, Never>()
    
    var emailExist = PassthroughSubject<Bool, Never>()
    var userNameExist = PassthroughSubject<Bool, Never>()
    var userCreatedStatus = PassthroughSubject<Bool, Never>()
    
    init()
    {
        setupEmail()
        setupusername()
        setupCreateAccountCheck()
    }
    
    
    func setupCreateAccountCheck()
    {
        email
            .combineLatest(username, password1, profileName)
            .map { (theEmail, theUsername, thePassword1, theProfileName) -> AnyPublisher<Bool, Never> in
                self.myFirebaseAPI.addNewUser(email: theEmail, password: thePassword1, username: theUsername, profileName: theProfileName)
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .sink { status in
                self.userCreatedStatus.send(status)
            }.store(in: &subs)
    }
    
    func setupEmail()
    {
        email
            .removeDuplicates()
            .debounce(for: DispatchQueue.SchedulerTimeType.Stride.seconds(0.5) , scheduler: DispatchQueue.main)
            .dropFirst(1)
            .map { [unowned self] inputEmail -> AnyPublisher<Bool, Never> in
                self.myFirebaseAPI.checkForExistingEmail(email: inputEmail).eraseToAnyPublisher()
            }
            .switchToLatest()
            .sink { [unowned self] status in
                self.emailExist.send(status)
            }.store(in: &subs)
    }
    
    func setupusername()
    {
        username
            .removeDuplicates()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .dropFirst(1)
            .map { [unowned self] inputUserName in
                self.myFirebaseAPI.checkForExistingUsername(username: inputUserName).eraseToAnyPublisher()
            }
            .switchToLatest()
            .sink { status in
                self.userNameExist.send(status)
            }
            .store(in: &subs)
    }
    
    
}
