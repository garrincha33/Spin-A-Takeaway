//
//  CustomAlertViewController.swift
//  Spin A Takeaway
//
//  Created by Richard Price on 19/02/2023.
//
import UIKit

class CustomAlertViewController: UIViewController {
    
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    let actionButton = UIButton()
    let cancelButton = UIButton()
    
    var titleText: String?
    var messageText: String?
    var actionText: String?
    var cancelText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 3
        containerView.layer.borderColor = UIColor.white.cgColor
        view.addSubview(containerView)
        

        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = titleText
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = messageText
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        containerView.addSubview(messageLabel)
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setTitle(actionText, for: .normal)
        actionButton.backgroundColor = .systemPurple
        actionButton.layer.cornerRadius = 10
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        containerView.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 250),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            actionButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
               actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
               actionButton.widthAnchor.constraint(equalToConstant: 100),
               actionButton.heightAnchor.constraint(equalToConstant: 44),
            
     
        ])
    }
    
    @objc func actionButtonTapped() {
        print("Action button tapped")
        dismiss(animated: true, completion: nil)
    }
}
        


