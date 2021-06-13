//
//  ItemDetailViewController.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/06/12.
//

import UIKit

class ItemDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        configureNavigation()
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
}
