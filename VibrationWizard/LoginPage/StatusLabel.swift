//
//  StatusLabel.swift
//  VibrationWizard
//
//  Created by Consultant on 1/30/23.
//

import UIKit

class StatusLabel: UILabel
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config()
    {
        translatesAutoresizingMaskIntoConstraints = false
        text = ""
        font = UIFont.preferredFont(forTextStyle: .headline)
        
    }
}
