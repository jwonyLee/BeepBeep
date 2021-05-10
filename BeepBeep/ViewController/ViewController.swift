//
//  ViewController.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/05/06.
//

import UIKit
import Then
import SnapKit

class ViewController: UIViewController {

    // MARK: - View Properties
    private let progressView = RoundView().then {
        $0.backgroundColor = .lightGray
    }

    private var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureNavigation()
        configureViews()
        setProgressViewConstraints()
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

        /* set collectionView */
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        guard let collectionView = collectionView else {
            fatalError("Error: collectionView is not been initialized")
        }
        view.addSubview(collectionView)
    }

    func setProgressViewConstraints() {
        progressView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            $0.height.equalTo(64)
        }
    }

    func setCollectionViewConstraints() {
        guard let collectionView = collectionView else {
            fatalError("Error: collectionView is not been initialized")
        }
        collectionView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.top.equalTo(progressView.snp.bottom).offset(16)
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
        return UICollectionViewCell()
    }
}
