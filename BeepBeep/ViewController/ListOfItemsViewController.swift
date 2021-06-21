//
//  ListOfItemsViewController.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/05/29.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ListOfItemsViewController: UIViewController {
    // MARK: - Properties
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: - View Properties
    private let tableView: UITableView = UITableView().then {
        $0.separatorStyle = .none
    }

    private let practiceButton: UIButton = UIButton().then {
        $0.titleLabel?.adjustsFontForContentSizeCategory = true
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        $0.backgroundColor = .label
        $0.setImage(UIImage(systemName: "mic"), for: .normal)
        $0.tintColor = .systemBackground
        $0.setTitle(I18N.practice.localized, for: .normal)
        $0.setTitleColor(.systemBackground, for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.contentVerticalAlignment = .center
        $0.contentHorizontalAlignment = .center
        $0.clipsToBounds = true
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        $0.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 24)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        configureNavigation()
        configureViews()
        setTableView()
        setTableViewConstraints()
        setPracticeButtonConstraints()
        bindInput()
        bindTableView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        practiceButton.layer.cornerRadius = practiceButton.frame.size.height / 2
    }
}

// MARK: - Private
extension ListOfItemsViewController {
    private func configureNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    }

    private func configureViews() {
        view.addSubview(tableView)
        view.addSubview(practiceButton)
    }

    private func setTableView() {
        tableView.backgroundColor = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func setTableViewConstraints() {
        tableView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            $0.bottom.equalTo(practiceButton.snp.top).offset(-16)
        }
    }

    private func setPracticeButtonConstraints() {
        practiceButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(32)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-32)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }

    private func bindInput() {
        practiceButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind {
                print("Tapped")
            }
            .disposed(by: disposeBag)
    }

    private func bindTableView() {
        tableView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                let itemDetailViewController: ItemDetailViewController = ItemDetailViewController()
                itemDetailViewController.title = "\(indexPath.row)"
                self.navigationController?.pushViewController(itemDetailViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView Datasource
extension ListOfItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = "text"
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

extension ListOfItemsViewController: UITableViewDelegate {
}
