//
//  PostCell.swift
//  LTechTest
//
//  Created by Антон Павлов on 02.07.2025.
//

import UIKit
import SnapKit
import Kingfisher

final class PostCell: UITableViewCell {
    
    // MARK: - Identifier
    
    static let reuseIdentifier = "PostCell"
    
    // MARK: - UI Elements
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .lBlack
        
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lBlack
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lGray
        
        return label
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lGray
        
        return view
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addElements()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    
    private func addElements() {
        [postImageView,
         titleLabel,
         subtitleLabel,
         dateLabel,
         separator
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        postImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(85)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.top)
            make.leading.equalTo(postImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        separator.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(dateLabel.snp.bottom).offset(16)
            make.leading.equalTo(postImageView)
            make.trailing.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Configuration
    
    func configure(with viewModel: DevExam.PostViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        dateLabel.text = viewModel.dateString
        
        if let url = viewModel.imageURL {
            let fullURL = URL(string: "http://dev-exam.l-tech.ru" + url.path)
            postImageView.kf.setImage(with: fullURL, placeholder: UIImage(named: "placeholder"))
        } else {
            postImageView.image = UIImage(named: "placeholder")
        }
    }
}
