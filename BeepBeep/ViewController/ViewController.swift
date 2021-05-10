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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        configureNavigation()
        configureViews()
        setCollectionView()
        setProgressViewConstraints()
        setCollectionHeaderLabelConstraints()
        setCollectionViewConstraints()
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
