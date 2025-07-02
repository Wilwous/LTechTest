//
//  DevExamDetailViewController.swift
//  LTechTest
//
//  Created by Антон Павлов on 02.07.2025.
//

//  DevExamDetailViewController.swift
//  LTechTest
//
//  Created by Антон Павлов on 02.07.2025.

import UIKit
import SnapKit
import Kingfisher

final class DevExamDetailViewController: UIViewController {
    
    // MARK: - Dependencies
    
    private let post: DevExam.PostViewModel
    
    // MARK: - UI Elements
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lGray
        label.text = post.dateString
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .lBlack
        label.numberOfLines = 0
        label.text = post.title
        
        return label
    }()
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        if let url = post.imageURL {
            let fullURL = URL(string: "http://dev-exam.l-tech.ru" + url.path)
            imageView.kf.setImage(with: fullURL)
        }
        
        return imageView
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .lBlack
        label.numberOfLines = 0
        label.text = post.subtitle
        
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon_arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .lBlack
        button.addTarget(
            self,
            action: #selector(backTapped),
            for: .touchUpInside
        )
        
        return button
    }()
    
    private lazy var heartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon_heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .lBlack
        
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(
            named: "icon_share_ios")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .lBlack
        
        return button
    }()
    
    // MARK: - Init
    
    init(post: DevExam.PostViewModel) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lWhite
        setupNavigationBar()
        addElements()
        setupConstraints()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationItem.title = ""
        
        let backItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backItem
        
        let shareItem = UIBarButtonItem(customView: shareButton)
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 16
        let heartItem = UIBarButtonItem(customView: heartButton)
        
        navigationItem.rightBarButtonItems = [shareItem, space, heartItem]
    }
    
    private func addElements() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [dateLabel,
         titleLabel,
         postImageView,
         subtitleLabel
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        postImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(220)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(32)
        }
    }
    
    // MARK: - Actions
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
