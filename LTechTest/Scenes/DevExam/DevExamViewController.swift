//
//  DevExamViewController.swift
//  LTechTest
//
//  Created by Антон Павлов on 02.07.2025.
//

import UIKit
import SnapKit

// MARK: - Protocol

protocol DevExamDisplayLogic: AnyObject {
    func displayPosts(viewModel: DevExam.LoadPosts.ViewModel)
}

final class DevExamViewController: UIViewController {

    // MARK: - Private Properties

    private var interactor: DevExamBusinessLogic?
    private var presenter: DevExamPresentationLogic?
    private var posts: [DevExam.PostViewModel] = []
    private var currentSort: DevExam.SortOption = .default

    // MARK: - UI Elements

    private lazy var sortLabel: UILabel = {
        let label = UILabel()
        label.text = currentSort.rawValue
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lBlack
        return label
    }()

    private lazy var sortStack: UIStackView = {
        let icon = UIImageView(image: UIImage(named: "arrow_triangle"))
        icon.contentMode = .scaleAspectFit

        let stack = UIStackView(arrangedSubviews: [sortLabel, icon])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.isUserInteractionEnabled = true
        stack.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(sortTapped)
        ))

        return stack
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 138
        table.register(
            PostCell.self,
            forCellReuseIdentifier: PostCell.reuseIdentifier
        )
        return table
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lWhite
        setupCleanSwift()
        setupNavigationBar()
        addElements()
        setupConstraints()
        interactor?.loadPosts(request: .init())
    }

    // MARK: - Setup

    private func setupCleanSwift() {
        let interactor = DevExamInteractor()
        let presenter = DevExamPresenter()

        self.interactor = interactor
        self.presenter = presenter

        interactor.presenter = presenter
        presenter.viewController = self
    }

    private func setupNavigationBar() {
        navigationItem.title = "Лента новостей"
        let refreshButton = UIBarButtonItem(
            image: UIImage(named: "icon_refresh"),
            style: .plain,
            target: self,
            action: #selector(refreshData)
        )
        refreshButton.tintColor = .lBlack
        navigationItem.rightBarButtonItem = refreshButton
    }

    private func addElements() {
        [sortStack, tableView].forEach { view.addSubview($0) }
    }

    private func setupConstraints() {
        sortStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().inset(16)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(sortStack.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    // MARK: - Sort

    private func applySort(_ option: DevExam.SortOption) {
        switch option {
        case .default:
            posts.sort { $0.title < $1.title }
        case .byDate:
            posts.sort { $0.originalDate > $1.originalDate }
        }
        tableView.reloadData()
    }

    // MARK: - Actions

    @objc private func sortTapped() {
        let vc = DevExamSortViewController(selectedOption: currentSort)
        vc.onOptionSelected = { [weak self] newOption in
            guard let self else { return }
            self.currentSort = newOption
            self.sortLabel.text = newOption.rawValue
            self.applySort(newOption)
        }
        present(vc, animated: true)
    }

    @objc private func refreshData() {
        interactor?.loadPosts(request: .init())
    }
}

// MARK: - DevExamDisplayLogic

extension DevExamViewController: DevExamDisplayLogic {
    func displayPosts(viewModel: DevExam.LoadPosts.ViewModel) {
        self.posts = viewModel.items
        applySort(currentSort)
    }
}

// MARK: - UITableViewDataSource

extension DevExamViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PostCell.reuseIdentifier,
            for: indexPath
        ) as? PostCell else {
            return UITableViewCell()
        }

        let post = posts[indexPath.row]
        cell.configure(with: post)
        cell.selectionStyle = .none

        return cell
    }
}
