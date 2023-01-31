//
//  CreateAccountBtn.swift
//  VibrationWizard
//
//  Created by Consultant on 1/30/23.
//

import UIKit

class CreateAccountBtn: UIButton
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure()
    {
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel?.text = "Create Account"
        backgroundColor = .systemOrange
        setTitle("Create Account", for: .normal)
    }
}
