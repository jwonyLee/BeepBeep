//
//  ItemDetailViewModel.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/07/05.
//

import AVFoundation
import Foundation

import RxSwift

class ItemDetailViewModel: NSObject {
    private let disposeBag: DisposeBag = DisposeBag()
    var item: Item = Item()
    private(set) var recordObservable: Observable<[Record]> = Observable.just([])
    
    // MARK: Audio
    private var audioPlayer: AVAudioPlayer?
    
    override init() {
        super.init()
        audioPlayer?.delegate = self
    }

    func setItem(at item: Item) {
        self.item = item
        fetchRecords(by: item)
    }

    func play(at index: Int) {
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        recordObservable
            .map { $0[index] }
            .subscribe(onNext: { [weak self] record in
                guard let self = self else { return }
                if let url: URL = URL(string: record.filePath) {
                    self.audioPlayer = try? AVAudioPlayer(contentsOf: url)
                    self.audioPlayer?.volume = audioSession.outputVolume
                    self.audioPlayer?.play()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension ItemDetailViewModel {
    private func fetchRecords(by item: Item) {
        if let findRecord: Observable<[Record]> = RealmManager.shared.findByRecord(at: item.identifier) {
            recordObservable = findRecord
        }
    }
}

extension ItemDetailViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            // 재생이 끝났다면
        }
    }
}
