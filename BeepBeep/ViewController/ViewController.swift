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

class ViewController: UIViewController {

    // MARK: - View Properties
    private let progressView = RoundView().then {
        $0.backgroundColor = UIColor(named: "BeepGray")
    }

    private let collectionHeaderLabel = UILabel().then {
        $0.text = "모음집"
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    }

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private var newCollectionsButton = UIButton().then {
        $0.titleLabel?.adjustsFontForContentSizeCategory = true
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        $0.backgroundColor = .label
        $0.setImage(UIImage(systemName: "folder.badge.plus"), for: .normal)
        $0.tintColor = .systemBackground
        $0.setTitle("새 모음집", for: .normal)
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
        setCollectionHeaderLabelConstraints()
        setCollectionViewConstraints()
        setCreateCollectionsButtonConstraints()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        newCollectionsButton.layer.cornerRadius = newCollectionsButton.frame.size.height / 2
    }
}

// MARK: - Private
private extension ViewController {
    func configureNavigation() {
        self.title = "BeepBeep"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configureViews() {
        view.addSubview(progressView)
        view.addSubview(collectionHeaderLabel)
        view.addSubview(collectionView)
        view.addSubview(newCollectionsButton)
    }

    func setCollectionView() {
        collectionView.backgroundColor = .none
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionsCell.self, forCellWithReuseIdentifier: CollectionsCell.identifier)
    }

    func setProgressViewConstraints() {
        progressView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            $0.height.equalTo(64)
        }
    }

    func setCollectionHeaderLabelConstraints() {
        collectionHeaderLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.top.equalTo(progressView.snp.bottom).offset(32)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
    }

    func setCollectionViewConstraints() {
        collectionView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.top.equalTo(collectionHeaderLabel.snp.bottom).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    func setCreateCollectionsButtonConstraints() {
        newCollectionsButton.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
}

// MARK: - CollectionView Datasource
extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionsCell.identifier, for: indexPath) as? CollectionsCell else {
            return CollectionsCell()
        }

        return cell
    }
}

// MARK: - CollectionView FlowLayout Delegate
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 72)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
}
