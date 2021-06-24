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
    private let viewModel = RecordViewModel()

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
        bindOutput()
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
            .bind { self.viewModel.recording() }
            .disposed(by: disposeBag)
    }

    func bindOutput() {
        viewModel.isRecordingRelay
            .subscribe(onNext: { isRecording in
                if isRecording {
                    self.moveToHalf()
                } else {
                    self.moveToTip()
                }
            })
            .disposed(by: disposeBag)
    }

    func moveToHalf() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: TimeInterval(0.3)) {
                (self.parent as! FloatingPanelController).move(to: .half, animated: false)
            }
        }
    }

    func moveToTip() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: TimeInterval(0.3)) {
                (self.parent as! FloatingPanelController).move(to: .tip, animated: false)
            }
        }
    }
}
