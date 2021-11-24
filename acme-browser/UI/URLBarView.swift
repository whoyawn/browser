//
//  URLBarView.swift
//  acme-browser
//
//  Created by Huyanh Hoang on 10/20/21.
//

import Foundation
import UIKit

protocol URLBarDelegate: AnyObject {
    func didTapBookmark(isBookmarked: Bool)
    func didTapRefresh()
    func didSubmitText(text: String)
}

class URLBarView: UIView {
    
    weak var delegate: URLBarDelegate?
    var isPageBookmarked = false {
        didSet {
            toggleBookmark()
        }
    }
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.text = ""
        textField.placeholder = "Search or enter website name"
        textField.textColor = .systemGray
        textField.returnKeyType = .go
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var refreshButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium, scale: .default)
        let image = UIImage(systemName: "arrow.clockwise", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(refreshTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.addArrangedSubview(bookmarkButton)
        stack.addArrangedSubview(refreshButton)
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func toggleBookmark() {
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium, scale: .default)
        let name = isPageBookmarked ? "star.fill" : "star"
        let image = UIImage(systemName: name, withConfiguration: config)
        bookmarkButton.setImage(image, for: .normal)
    }
    
    private func setupSubviews() {
        addSubview(textField)
        addSubview(buttonStack)
        
        toggleBookmark()
        
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8).isActive = true
        textField.trailingAnchor.constraint(equalTo: buttonStack.leadingAnchor).isActive = true
        textField.delegate = self
        
        buttonStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        buttonStack.widthAnchor.constraint(equalToConstant: 48).isActive = true
        buttonStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        buttonStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    @objc func bookmarkTapped() {
        delegate?.didTapBookmark(isBookmarked: isPageBookmarked)
    }

    @objc func refreshTapped() {
        delegate?.didTapRefresh()
    }
    
    func updateTextField(text: String) {
        textField.text = text
    }
}

extension URLBarView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            delegate?.didTapRefresh()
            return true
        }
        delegate?.didSubmitText(text: text)
        textField.resignFirstResponder()
        return true
    }
}
