//
//  RateTableViewCell.swift
//  Rates
//
//  Created by Diomidis Papas on 13/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import UIKit

struct RateTableViewCellDelegate {
    let isEditable: Bool
    let inputValidators: [Validator]
}

struct RateTableViewCellDataSource {
    let title: String
    let subtitle: String?
    let rate: String?
    let rateUnderlineColor: UIColor
    let ratePlaceholder: String
    let ratePlaceholderColor: UIColor
}

extension RateTableViewCellDataSource: Equatable {
    static func ==(lhs: RateTableViewCellDataSource, rhs: RateTableViewCellDataSource) -> Bool {
        return lhs.title == lhs.title &&           
            rhs.subtitle == rhs.subtitle &&
            lhs.rate == rhs.rate &&
            lhs.rateUnderlineColor == rhs.rateUnderlineColor
    }
}

final class RateTableViewCell: UITableViewCell {
    
    typealias RateTableViewCellTextFieldChangeClosure = (String) -> ()
    
    var textFieldChangeClosure: RateTableViewCellTextFieldChangeClosure?
    
    private var dataSource: RateTableViewCellDataSource?
    
    private var delegate: RateTableViewCellDelegate?
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let labelVerticalStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .decimalPad
        textField.textAlignment = .right
        textField.addTarget(self, action: #selector(textFieldTextDidChange(sender:)), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    // MARK: Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildViewHierarchy()
        setupConstraints()
        setupDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    
    func configure(with dataSource: RateTableViewCellDataSource, delegate: RateTableViewCellDelegate) {
        configure(with: dataSource)
        configure(with: delegate)
    }

    func configure(with dataSource: RateTableViewCellDataSource) {
        self.dataSource = dataSource
        titleLabel.attributedText = NSAttributedString(string: dataSource.title, attributes: TextAttributes.label.body())
        subtitleLabel.attributedText = NSAttributedString(string: dataSource.subtitle ?? "", attributes: TextAttributes.label.caption())
       
        if let rate = dataSource.rate {
            textField.attributedText = NSAttributedString(string: rate, attributes: TextAttributes.textField.body(with: .black, underlineColor: dataSource.rateUnderlineColor))
        }
        
        textField.attributedPlaceholder = NSAttributedString(string: dataSource.ratePlaceholder, attributes: TextAttributes.textField.body(with: dataSource.ratePlaceholderColor, underlineColor: dataSource.rateUnderlineColor))
        
    }
    
    func configure(with delegate: RateTableViewCellDelegate) {
        self.delegate = delegate
        textField.isUserInteractionEnabled = delegate.isEditable
    }
    
    // MARK: Private
    
    private func buildViewHierarchy() {
        labelVerticalStackView.addArrangedSubview(titleLabel)
        labelVerticalStackView.addArrangedSubview(subtitleLabel)
        horizontalStackView.addArrangedSubview(labelVerticalStackView)
        horizontalStackView.addArrangedSubview(textField)
        contentView.addSubview(horizontalStackView)
    }
    
    private func setupConstraints() {
        let guide = contentView.readableContentGuide
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: guide.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            ])
    }
    
    private func setupDefaults() {
        backgroundColor = .white
        selectionStyle = .none
    }
    
    @objc private func textFieldTextDidChange(sender : UITextField) {
        if var text = textField.text {
            
            if text == "." {
                text = "0."
            }
            
            let underlineColor = dataSource?.rateUnderlineColor ?? .black
            textField.attributedText = NSAttributedString(string: text, attributes: TextAttributes.textField.body(with: .black, underlineColor: underlineColor))
            textFieldChangeClosure?(text)
        }
    }
    
    // MARK: Override
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
        subtitleLabel.attributedText = nil
        textField.attributedText = nil
        textField.attributedPlaceholder = nil
    }
    
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
}

extension RateTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        let validatableText = currentText + string
        
        if let inputValidators = delegate?.inputValidators {
            return validatableText.validate(inputValidators)
        } else {
            return true
        }
    }

}
