//
//  PlaceholderViewController.swift
//  LTechTest
//
//  Created by Антон Павлов on 02.07.2025.
//

import UIKit
import SnapKit

final class PlaceholderViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "questionmark")
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Пусто"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .lBlack
        
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Здесь пока ничего нет"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .lGray
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - Init

    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lWhite
        addElements()
        setupConstraints()
    }
    
    // MARK: - Setup View
    
    private func addElements() {
        [imageView,
         titleLabel,
         subtitleLabel
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.width.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(32)
        }
    }
}
