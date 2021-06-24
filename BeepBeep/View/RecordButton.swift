//
//  RecordButton.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/06/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

class RecordButton: UIButton {

    private let animationDuration = 0.4
    private var isRecording: Bool = false
    private var circleSize: Int = 50
    private var squareSize: Int {
        get {
            return Int(Double(circleSize) * 0.7)
        }
    }
    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        self.rx.tap
            .bind { self.tapped() }
            .disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configure()
        self.rx.tap
            .bind { self.tapped() }
            .disposed(by: disposeBag)
    }

    init(_ circleSize: Int) {
        super.init(frame: .zero)

        self.circleSize = circleSize

        configure()
        self.rx.tap
            .bind { self.tapped() }
            .disposed(by: disposeBag)
    }

}

private extension RecordButton {
    func configure() {
        self.snp.makeConstraints {
            $0.width.equalTo(self.circleSize)
            $0.height.equalTo(self.circleSize)
        }

        self.setTitle("", for: .normal)
        self.backgroundColor = .systemRed
        self.layer.cornerRadius = CGFloat(circleSize) / 2
    }

    func tapped() {
        if isRecording {
            UIView.animate(withDuration: animationDuration) {
                self.snp.updateConstraints {
                    $0.width.equalTo(self.circleSize)
                    $0.height.equalTo(self.circleSize)
                }
                self.layoutIfNeeded()

                self.layer.cornerRadius = self.frame.height / 2
            }
        } else {
            UIView.animate(withDuration: animationDuration) {
                self.snp.updateConstraints {
                    $0.width.equalTo(self.squareSize)
                    $0.height.equalTo(self.squareSize)
                }
                self.layoutIfNeeded()
                self.layer.cornerRadius = 0
            }
        }

        isRecording = !isRecording
    }
}
