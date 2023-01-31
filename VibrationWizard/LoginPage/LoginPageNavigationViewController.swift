//
//  LoginPageNavigationViewController.swift
//  VibrationWizard
//
//  Created by Consultant on 1/30/23.
//

import UIKit

class LoginPageNavigationViewController: UINavigationController
{
    let loginPageVC = LoginPageViewController()
    
    init()
    {
        super.init(rootViewController: loginPageVC)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
