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
    private let identifier: String = "ListOfItemsCell"
    private let disposeBag: DisposeBag = DisposeBag()
    let viewModel: ListOfItemsViewModel = ListOfItemsViewModel()

    // MARK: - View Properties
    private let tableView: UITableView = UITableView().then {
        $0.separatorStyle = .none
    }

    private let practiceButton: UIButton = UIButton().then {
        $0.titleLabel?.adjustsFontForContentSizeCategory = true
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.font = UIFont.pretendardBody
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
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.pretendardHeadline]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
    }

    private func configureViews() {
        view.addSubview(tableView)
        view.addSubview(practiceButton)
    }

    private func setTableView() {
        tableView.backgroundColor = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.identifier)
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
        viewModel.itemObservable
            .bind(to: tableView.rx.items(cellIdentifier: self.identifier)) { _, element, cell in
                cell.textLabel?.text = element.title
                cell.accessoryType = .disclosureIndicator
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                let itemDetailViewController: ItemDetailViewController = ItemDetailViewController()
                self.viewModel.itemObservable
                    .compactMap { $0[indexPath.row] }
                    .subscribe { item in
                        itemDetailViewController.viewModel.setItem(at: item)
                    }
                    .disposed(by: self.disposeBag)
                self.navigationController?.pushViewController(itemDetailViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }

    @objc
    private func addItem() {
        let alertViewController: UIAlertController = UIAlertController(title: I18N.addItemTitle.localized,
                                                                       message: "질문을 입력해주세요.",
                                                                       preferredStyle: .alert)
        let addAction: UIAlertAction = UIAlertAction(title: I18N.confirm.localized, style: .default, handler: { [weak self] _ in
            let title: String = alertViewController.textFields?[0].text ?? ""
            let content: String = alertViewController.textFields?[1].text ?? ""
            self?.viewModel.addItem(with: title, content: content, interval: TimeInterval())
        })
        let cancleAction: UIAlertAction = UIAlertAction(title: I18N.cancle.localized, style: .cancel)
        alertViewController.addAction(addAction)
        alertViewController.addAction(cancleAction)

        alertViewController.addTextField { $0.placeholder = "질문을 입력해주세요." }
        alertViewController.addTextField { $0.placeholder = "내용을 입력해주세요." }

        self.present(alertViewController, animated: true)
    }
}
