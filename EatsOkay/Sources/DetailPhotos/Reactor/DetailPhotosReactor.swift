//
//  DetailPhotosReactor.swift
//  EatsOkay
//
//  Created by LCH on 7/1/25.
//

import Foundation
import ReactorKit
import RxSwift

class DetailPhotosReactor: Reactor {
    
    var initialState: State
    
    let networkManager = NetworkManager.shared
    
    init(with data: DetailPhotos) {
        self.initialState = State(
            photosUri: data.photosUri,
            storeName: data.sotoreName,
            scollIndex: data.selectedIndex
        )
    }
    
    enum Action {
        case initialFetch
        case imagePaged(Int)
        case previewTapped(Int)
        case backButtonTapped
    }
    
    enum Mutation {
        case setCollectionViewData([DetailPhotosSectionOfCellModel])
        case setStoreName(String)
        case setScollIndex(Int)
        case setSelectedIndex(Int?)
        case setDissmiss(Void?)
    }
    
    struct State {
        fileprivate var photosUri: [String]
        var collectionViewData = [DetailPhotosSectionOfCellModel]()
        var storeName: String
        var scollIndex: Int
        @Pulse var selectedIndex: Int?
        @Pulse var dissmissRequest: Void?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initialFetch:
            
            let dataSource = makeDataSource(with: currentState.scollIndex)
            
            return Observable.concat(
                Observable.just(.setCollectionViewData(dataSource)),
                Observable.just(.setSelectedIndex(currentState.scollIndex)),
                Observable.just(.setStoreName(currentState.storeName))
            )
        case .imagePaged(let pagedIndex):
            
            let dataSource = makeDataSource(with: pagedIndex)
            
            return Observable.concat(
                Observable.just(.setCollectionViewData(dataSource)),
                Observable.just(.setScollIndex(pagedIndex))
            )
            
        case .previewTapped(let selectedIndex):
            
            let dataSource = makeDataSource(with: selectedIndex)
            
            return Observable.concat(
                Observable.just(.setCollectionViewData(dataSource)),
                Observable.just(.setSelectedIndex(selectedIndex))
            )
            
        case .backButtonTapped:
            return Observable.just(.setDissmiss(Void()))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var newState = state
        
        switch mutation {
        case let .setCollectionViewData(data):
            newState.collectionViewData = data
            
        case let .setStoreName(storeName):
            newState.storeName = storeName
            
        case let .setScollIndex(selectedIndex):
            newState.scollIndex = selectedIndex
            
        case let .setSelectedIndex(index):
            newState.selectedIndex = index
            
        case let .setDissmiss(backView):
            newState.dissmissRequest = backView
        }
        
        return newState
    }
    
    private func makeDataSource(with inputIndex: Int) -> [DetailPhotosSectionOfCellModel] {
        
        let mainPhotosSectionItems: [DetailPhotosSectionOfCellModel.CellModel] = currentState.photosUri.map {
            .mainPhotosSection(imageName: $0)
        }
        
        let totalPhotosSectionItems = currentState.photosUri.enumerated().map { index, uri in
            DetailPhotosSectionOfCellModel.CellModel.totalPhotosSection(
                imageName: uri,
                isSelected: index == inputIndex
            )
        }
        
        let dataSource: [DetailPhotosSectionOfCellModel] = [
            .init(section: .mainPhotosSection, items: mainPhotosSectionItems),
            .init(section: .totalPhotosSection, items: totalPhotosSectionItems)
        ]
        
        return dataSource
    }
}
