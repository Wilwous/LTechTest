//
//  DevExamSortViewController.swift
//  LTechTest
//
//  Created by Антон Павлов on 02.07.2025.
//

import UIKit
import SnapKit

final class DevExamSortViewController: UIViewController {

    // MARK: - Public

    var selectedOption: DevExam.SortOption
    var onOptionSelected: ((DevExam.SortOption) -> Void)?

    // MARK: - UI

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lWhite
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var grabberView: UIView = {
        let view = UIView()
        view.backgroundColor = .lGray
        view.layer.cornerRadius = 2.5
        return view
    }()

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Сортировка"
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .lBlack
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon_close"), for: .normal)
        button.tintColor = .lGray
        button.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        return button
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.isScrollEnabled = false
        table.separatorStyle = .none
        table.rowHeight = 48
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    // MARK: - Init

    init(selectedOption: DevExam.SortOption) {
        self.selectedOption = selectedOption
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        setupTapOutsideDismiss()
        addElements()
        setupConstraints()
    }

    // MARK: - Setup

    private func addElements() {
        view.addSubview(containerView)
        [grabberView, headerLabel, closeButton, tableView].forEach { containerView.addSubview($0) }
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(190)
        }

        grabberView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(5)
        }

        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(grabberView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
        }

        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerLabel)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupTapOutsideDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !containerView.frame.contains(location) {
            dismiss(animated: true)
        }
    }

    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource & Delegate

extension DevExamSortViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DevExam.SortOption.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = DevExam.SortOption.allCases[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        var config = UIListContentConfiguration.valueCell()
        config.text = option.rawValue
        config.textProperties.font = .systemFont(ofSize: 17)
        config.textProperties.color = .lBlack

        if option == selectedOption {
            let checkmark = UIImageView(image: UIImage(named: "icon_checkmark"))
            checkmark.contentMode = .scaleAspectFit
            cell.accessoryView = checkmark
        } else {
            cell.accessoryView = nil
        }

        cell.contentConfiguration = config
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newOption = DevExam.SortOption.allCases[indexPath.row]
        selectedOption = newOption
        tableView.reloadData()
        dismiss(animated: true) {
            self.onOptionSelected?(newOption)
        }
    }
}
