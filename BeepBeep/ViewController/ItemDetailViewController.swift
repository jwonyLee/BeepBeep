//
//  ItemDetailViewController.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/06/12.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ItemDetailViewController: UIViewController {

    // MARK: - Properties
    let disposeBag = DisposeBag()

    // MARK: - View Properties
    private let titleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        $0.text = "What is your favorite?"
        $0.textColor = .label
    }

    private let answerTextView = UITextView().then {
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.isEditable = false
        $0.backgroundColor = UIColor(named: "BeepGray")
        $0.textColor = .label
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }

    private let recordTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        $0.text = "Detail Blah"
        $0.textColor = .label
    }

    private let tableView = UITableView(frame: .zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        configureNavigation()
        configureViews()
        setTableView()
        setTitleLabelConstraints()
        setAnswerTextViewConstraints()
        setRecordTitleLabelConstraints()
        setTableViewConstraints()
    }
}

// MARK: - Private
private extension ItemDetailViewController {

    var menuItems: [UIAction] {
        return [
            UIAction(title: I18N.modify, image: UIImage(systemName: "pencil"), handler: { _ in }),
            UIAction(title: I18N.delete, image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in })
        ]
    }

    var menu: UIMenu {
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
    }

    func configureNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = false

        if #available(iOS 14.0, *) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",
                                                                     image: UIImage(systemName: "ellipsis.circle"),
                                                                     primaryAction: nil,
                                                                     menu: menu)
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(moreActionTapped))
        }
    }

    @objc func moreActionTapped(_ sender: UIBarButtonItem) {
        if #available(iOS 14.0, *) {

        } else {
            let alert = UIAlertController(title: nil, message: I18N.actionsheetMessage, preferredStyle: .actionSheet)

            let deleteAction = UIAlertAction(title: I18N.modify, style: .default, handler: { _ in })
            let saveAction = UIAlertAction(title: I18N.delete, style: .destructive, handler: { _ in })
            let cancelAction = UIAlertAction(title: I18N.cancle, style: .cancel, handler: { _ in })

            alert.addAction(deleteAction)
            alert.addAction(saveAction)
            alert.addAction(cancelAction)

            self.present(alert, animated: true, completion: nil)
        }
    }

    func configureViews() {
        view.addSubview(titleLabel)
        view.addSubview(answerTextView)
        view.addSubview(recordTitleLabel)
        view.addSubview(tableView)
    }

    func setTableView() {
        tableView.backgroundColor = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(32)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-32)
        }
    }

    func setAnswerTextViewConstraints() {
        answerTextView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.3)
        }
    }

    func setRecordTitleLabelConstraints() {
        recordTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(answerTextView.snp.bottom).offset(32)
            $0.trailing.equalTo(titleLabel.snp.trailing)
        }
    }

    func setTableViewConstraints() {
        tableView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(recordTitleLabel.snp.bottom).offset(32)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.bottom.equalToSuperview().offset(-32)
        }
    }
}
