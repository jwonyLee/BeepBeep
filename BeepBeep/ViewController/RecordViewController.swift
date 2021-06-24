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
    private let disposeBag: DisposeBag = DisposeBag()
    private let viewModel: RecordViewModel = RecordViewModel()

    // MARK: - View Properties
    private let recordView: UIView = UIView().then {
        $0.layer.cornerRadius = 33
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.secondaryLabel.cgColor
        $0.layer.masksToBounds = true
    }

    private let recordButton: RecordButton = RecordButton()

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

extension RecordViewController {
    private func configureViews() {
        recordView.addSubview(recordButton)
        view.addSubview(recordView)
    }

    private func setRecordViewConstraints() {
        recordView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-32)
            $0.width.equalTo(66)
            $0.height.equalTo(recordView.snp.width)
        }
    }

    private func setRecordButtonConstraints() {
        recordButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func bindInput() {
        recordButton.rx.tap
            .bind { self.viewModel.recording() }
            .disposed(by: disposeBag)
    }

    private func bindOutput() {
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

    private func moveToHalf() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: TimeInterval(0.3)) {
                (self.parent as? FloatingPanelController)?.move(to: .half, animated: false)
            }
        }
    }

    private func moveToTip() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: TimeInterval(0.3)) {
                (self.parent as? FloatingPanelController)?.move(to: .tip, animated: false)
            }
        }
    }
}
