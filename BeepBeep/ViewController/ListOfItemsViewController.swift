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
    private let disposeBag = DisposeBag()

    // MARK: - View Properties
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
    }

    private let practiceButton = UIButton().then {
        $0.titleLabel?.adjustsFontForContentSizeCategory = true
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        $0.backgroundColor = .label
        $0.setImage(UIImage(systemName: "mic"), for: .normal)
        $0.tintColor = .systemBackground
        $0.setTitle("연습하기", for: .normal)
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
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        practiceButton.layer.cornerRadius = practiceButton.frame.size.height / 2
    }
}

// MARK: - Private
private extension ListOfItemsViewController {
    func configureNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    }

    func configureViews() {
        view.addSubview(tableView)
        view.addSubview(practiceButton)
    }

    func setTableView() {
        tableView.backgroundColor = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setTableViewConstraints() {
        tableView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    func setPracticeButtonConstraints() {
        practiceButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(32)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-32)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }

    func bindInput() {
        practiceButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind {
                print("Tapped")
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView Datasource
extension ListOfItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = "text"
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

extension ListOfItemsViewController: UITableViewDelegate {

}
