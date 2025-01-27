//
//  DreamWriteViewModel.swift
//  RD-Navigator
//
//  Created by Junho Lee on 2022/09/29.
//  Copyright © 2022 RecorDream. All rights reserved.
//

import AVFoundation
import Foundation

import Domain
import RD_Core

import RxSwift
import RxRelay

public class DreamWriteViewModel: ViewModelType {
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Observable<Void>
        let datePicked: Observable<String>
        let voiceRecorded: Observable<Data?>
        let titleTextChanged: Observable<String>
        let contentTextChanged: Observable<String>
        let emotionChagned: Observable<Int?>
        let genreListChagned: Observable<[Int]?>
        let noteTextChanged: Observable<String>
        let saveButtonTapped: Observable<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        var writeButtonEnabled = PublishRelay<Bool>()
        var writeRequestSuccess = PublishRelay<String?>()
        var dreamWriteModelFetched = BehaviorRelay<DreamWriteEntity?>(value: nil)
        var loadingStatus = PublishRelay<Bool>()
        var showNetworkAlert = PublishRelay<Void>()
    }
    
    // MARK: - Properties
    
    private let useCase: DreamWriteUseCase
    private let disposeBag = DisposeBag()
    private var player: AVAudioPlayer?
    
    public enum DreamWriteViewModelType {
        case write
        case modify(postId: String, audioURL: URL?)
        
        var isModifyView: Bool {
            switch self {
            case .write: return false
            case .modify: return true
            }
        }
        
        var audioURL: URL? {
            switch self {
            case .write: return nil
            case .modify(_, let url): return url
            }
        }
    }
    
    public var viewModelType = DreamWriteViewModelType.write
    
    let writeRequestEntity = BehaviorRelay<DreamWriteRequest>(value: .init(title: nil, date: "", content: nil, emotion: nil, genre: nil, note: nil, voice: nil))
    var voiceId: String? = nil
    
    // MARK: - Initializer
    
    public init(useCase: DreamWriteUseCase, viewModelType: DreamWriteViewModelType) {
        self.useCase = useCase
        self.viewModelType = viewModelType
    }
}

extension DreamWriteViewModel {
    public func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        Observable.combineLatest(input.datePicked.startWith(.toDateWithYYMMDD("")()),
                                 input.voiceRecorded.startWith(nil),
                                 input.titleTextChanged.startWith(""),
                                 input.contentTextChanged.startWith(""),
                                 input.emotionChagned.startWith(nil),
                                 input.genreListChagned.startWith(nil),
                                 input.noteTextChanged.startWith(""))
        .subscribe(onNext: { (date, urlTime, title, content, emotion, genreList, note) in
            self.writeRequestEntity.accept(DreamWriteRequest.init(title: title,
                                                                  date: date,
                                                                  content: content,
                                                                  emotion: emotion,
                                                                  genre: genreList,
                                                                  note: note,
                                                                  voice: self.voiceId))
            self.useCase.titleTextValidate(text: title)
        }).disposed(by: disposeBag)
        
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewDidLoad.subscribe(onNext: { _ in
            if case let .modify(postId, _) = self.viewModelType {
                DispatchQueue.main.async {
                    output.loadingStatus.accept(true)
                }
                self.useCase.fetchDreamRecord(recordId: postId)
            }
        }).disposed(by: disposeBag)
        
        input.voiceRecorded.subscribe(onNext: { data in
            if let data = data {
                output.loadingStatus.accept(true)
                self.useCase.uploadVoice(voiceData: data)
            } else {
                self.voiceId = nil
            }
        }).disposed(by: disposeBag)
        
        input.saveButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                output.loadingStatus.accept(true)
                switch owner.viewModelType {
                case .write:
                    owner.useCase.writeDreamRecord(request: owner.writeRequestEntity.value, voiceId: owner.voiceId)
                case let .modify(postId, _):
                    owner.useCase.modifyDreamRecord(request: owner.writeRequestEntity.value, voiceId: owner.voiceId, recordId: postId)
                }
            }).disposed(by: disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        let fetchedModel = useCase.fetchedRecord
        fetchedModel
            .withUnretained(self)
            .subscribe(onNext: { owner, entity in
                output.loadingStatus.accept(false)
                guard var entity = entity else {
                    return
                }
                
                do {
                    guard let url = owner.viewModelType.audioURL else { throw NSError() }
                    owner.player = try AVAudioPlayer(contentsOf: url)
                    let duration = owner.player?.duration
                    entity.changeRecordTime(time: duration ?? 0)
                } catch {
                    debugPrint("invalid url input")
                }
                
                output.dreamWriteModelFetched.accept(entity)
                owner.writeRequestEntity.accept(entity.toRequest())
            }).disposed(by: disposeBag)
        
        let writeRelay = useCase.writeSuccess
        writeRelay.subscribe(onNext: { recordId in
            output.writeRequestSuccess.accept(recordId)
            output.loadingStatus.accept(false)
        }).disposed(by: disposeBag)
        
        let writeEnabled = useCase.isWriteEnabled
        writeEnabled.subscribe(onNext: { status in
            output.writeButtonEnabled.accept(status)
        }).disposed(by: disposeBag)
        
        let uploadedVoiceId = useCase.uploadedVoice
        uploadedVoiceId.subscribe(onNext: { voiceId in
            self.voiceId = voiceId
            output.loadingStatus.accept(false)
            guard voiceId != nil else {
                output.showNetworkAlert.accept(())
                return
            }
        }).disposed(by: disposeBag)
    }
}
