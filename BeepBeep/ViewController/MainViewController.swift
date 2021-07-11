//
//  ViewController.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/05/06.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RealmSwift

class MainViewController: UIViewController {
    // MARK: - Properties
    private let disposeBag: DisposeBag = DisposeBag()
    private let viewModel: MainViewModel = MainViewModel()

    // MARK: - View Properties
    private let progressView: RoundView = RoundView().then {
        $0.backgroundColor = UIColor(named: "BeepGray")
    }

    private let categoryHeaderLabel: UILabel = UILabel().then {
        $0.text = I18N.collection.localized
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    }

    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private var newCategoryButton: UIButton = UIButton().then {
        $0.titleLabel?.adjustsFontForContentSizeCategory = true
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        $0.backgroundColor = .label
        $0.setImage(UIImage(systemName: "folder.badge.plus"), for: .normal)
        $0.tintColor = .systemBackground
        $0.setTitle(I18N.newCollection.localized, for: .normal)
        $0.setTitleColor(.systemBackground, for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.contentVerticalAlignment = .center
        $0.contentHorizontalAlignment = .leading
        $0.clipsToBounds = true
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        $0.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 24)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        configureNavigation()
        configureViews()
        setCollectionView()
        setProgressViewConstraints()
        setCategoryHeaderLabelConstraints()
        setCollectionViewConstraints()
        setNewCategoryButtonConstraints()
        bindCollectionView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        newCategoryButton.layer.cornerRadius = newCategoryButton.frame.size.height / 2
    }
}

// MARK: - Private
extension MainViewController {
    private func configureNavigation() {
        self.title = I18N.title.localized
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureViews() {
        view.addSubview(progressView)
        view.addSubview(categoryHeaderLabel)
        view.addSubview(collectionView)
        view.addSubview(newCategoryButton)

        newCategoryButton.addTarget(self, action: #selector(createCategory), for: .touchUpInside)
    }

    private func setCollectionView() {
        collectionView.backgroundColor = .none
        collectionView.delegate = self
        collectionView.register(CollectionsCell.self, forCellWithReuseIdentifier: CollectionsCell.identifier)
    }

    private func setProgressViewConstraints() {
        progressView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            $0.height.equalTo(64)
        }
    }

    private func setCategoryHeaderLabelConstraints() {
        categoryHeaderLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.top.equalTo(progressView.snp.bottom).offset(32)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
    }

    private func setCollectionViewConstraints() {
        collectionView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.top.equalTo(categoryHeaderLabel.snp.bottom).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private func setNewCategoryButtonConstraints() {
        newCategoryButton.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }

    @objc
    private func createCategory() {
        self.navigationController?.pushViewController(CreateCategoryViewController(), animated: true)
    }

    private func bindCollectionView() {
        viewModel.categoryObservable
            .bind(to: collectionView.rx.items(cellIdentifier: CollectionsCell.identifier, cellType: CollectionsCell.self)) { _, element, cell in
                cell.configure(element)
            }
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                let listOfItemsViewController: ListOfItemsViewController = ListOfItemsViewController()
                /*
                 TODO:
                 - listOfItemViewController.title bind viewModel.categorySubject[indexPath.row].emoji + viewModel.categorySubject[indexPath.row].name
                 - listOfItemsViewController.viewModel.items pass viewModel.categorySubject[indexPath.row].items
                 */
                self.navigationController?.pushViewController(listOfItemsViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - CollectionView FlowLayout Delegate
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 72)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
}
