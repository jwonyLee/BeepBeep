//
//  ListOfItemsViewController.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/05/29.
//

import UIKit
import SnapKit
import Then

class ListOfItemsViewController: UIViewController {

    // MARK: - View Properties

    private let tableView = UITableView().then {
        $0.separatorStyle = .none
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        configureNavigation()
        configureViews()
        setTableView()
        setTableViewConstraints()
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
