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

class RecordViewModel: NSObject {
    private let disposeBag: DisposeBag = DisposeBag()
    private var isRecording: Bool = false {
        didSet {
            isRecordingRelay.accept(isRecording)
        }
    }
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private lazy var recordURL: URL = {
        var documentsURL: URL = {
            let paths: [URL] = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths.first!
        }()
        let fileName: String = UUID().uuidString + ".m4a"
        let url: URL = documentsURL.appendingPathComponent(fileName)
        return url
    }()
    let isRecordingRelay: PublishRelay<Bool> = PublishRelay<Bool>()

    override init() {
        super.init()
        configureAudioRecorder()
    }

    func recording() {
        requestMicrophoneAccess { [weak self] allowed in
            if allowed { // 녹음 권한 허용
                if let recorder: AVAudioRecorder = self?.audioRecorder {
                    if recorder.isRecording { // 현재 녹음 중이므로, 녹음 정지
                        self?.stop()
                    } else { // 녹음 시작
                        self?.record()
                    }
                }
                DispatchQueue.main.async {
                    self?.isRecording.toggle()
                }
            } else { // 녹음 권한 거부
                print("녹음 권한 거부해서 녹음을 할 수 없어요.")
            }
        }
    }

    /// 마이크 접근 권한 요청
    func requestMicrophoneAccess(completion: @escaping (Bool) -> Void) {
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
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
    }
}

// MARK: - Private
extension RecordViewModel {
    private func configureAudioRecorder() {
        let recorderSettings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 320_000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44_100.0
        ]
        audioRecorder = try? AVAudioRecorder(url: recordURL, settings: recorderSettings)
        audioRecorder?.delegate = self
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.prepareToRecord()
    }

    /// 녹음 시작
    private func record() {
        if let recorder: AVAudioRecorder = self.audioRecorder {
            let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
            } catch {
                fatalError(error.localizedDescription)
            }
            recorder.record()
        }
    }

    /// 녹음 정지
    private func stop() {
        if let recorder: AVAudioRecorder = self.audioRecorder {
            recorder.stop()
            let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(false)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    /// save Record in Realm
    private func saveRecord(_ newRecord: Record) {
        RealmManager.add(newRecord)
    }
}

// MARK: - Delegate
extension RecordViewModel: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag { // 녹음이 끝났을 때
            self.audioPlayer = try? AVAudioPlayer(contentsOf: self.recordURL)
            let duration: TimeInterval = self.audioPlayer?.duration ?? 0.0
            let record: Record = Record(filePath: self.recordURL.absoluteString, interval: duration)
            self.saveRecord(record)
        }
    }
}
