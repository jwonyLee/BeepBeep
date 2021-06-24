//
//  RecordViewModel.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/06/21.
//

import Foundation

import RxSwift
import RxCocoa

class RecordViewModel {
    private let disposeBag = DisposeBag()
    private var isRecording = false {
        didSet {
            isRecordingRelay.accept(isRecording)
        }
    }
    let isRecordingRelay = PublishRelay<Bool>()

    func recording() {
        isRecording = !isRecording
    }
}
