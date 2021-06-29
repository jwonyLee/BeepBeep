//
//  RecordViewModel.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/06/21.
//

import Foundation
import AVFoundation

import RxSwift
import RxCocoa

class RecordViewModel {
    private let disposeBag: DisposeBag = DisposeBag()
    private var isRecording: Bool = false {
        didSet {
            isRecordingRelay.accept(isRecording)
        }
    }
    let isRecordingRelay: PublishRelay<Bool> = PublishRelay<Bool>()

    func recording() {
        isRecording.toggle()
    }

    /// 마이크 접근 권한 요청
    func requestMicrophoneAccess(completion: @escaping (Bool) -> Void) {
        do {
            let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
            try audioSession.setActive(true)

            switch audioSession.recordPermission {
            case .undetermined: // 아직 녹음 권한 요청이 되지 않음, 사용자에게 권한 요청
                audioSession.requestRecordPermission({ allowed in
                    completion(allowed)
                })
            case .denied: // 사용자가 녹음 권한 거부, 사용자가 직접 설정 화면에서 권한 허용을 하게끔 유도
                print("[Failure] Record Permission is Denied.")
                completion(false)
            case .granted: // 사용자가 녹음 권한 허용
                print("[Success] Record Permission is Granted.")
                completion(true)
            @unknown default:
                fatalError("[ERROR] Record Permission is Unknown Default.")
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
