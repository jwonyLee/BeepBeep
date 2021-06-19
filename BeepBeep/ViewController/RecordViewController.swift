//
//  RecordViewController.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/06/13.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import FloatingPanel

class RecordViewController: UIViewController {

    // MARK: - Properties
    private let disposeBag = DisposeBag()

    // MARK: - View Properties
    let recordView = UIView().then {
        $0.layer.cornerRadius = 33
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.secondaryLabel.cgColor
        $0.layer.masksToBounds = true
    }

    let recordButton = RecordButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureViews()
        setRecordViewConstraints()
        setRecordButtonConstraints()
        bindInput()
    }
}

private extension RecordViewController {
    func configureViews() {
        recordView.addSubview(recordButton)
        view.addSubview(recordView)
    }

    func setRecordViewConstraints() {
        recordView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-32)
            $0.width.equalTo(66)
            $0.height.equalTo(recordView.snp.width)
        }
    }

    func setRecordButtonConstraints() {
        recordButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func bindInput() {
        recordButton.rx.tap
            .delay(.milliseconds(5), scheduler: MainScheduler.instance)
            .bind { self.moveToHalf() }
            .disposed(by: disposeBag)
    }

    func moveToHalf() {
        (self.parent as! FloatingPanelController).move(to: .half, animated: true)
    }
}
