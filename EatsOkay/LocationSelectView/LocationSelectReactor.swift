//
//  LocationSelectReactor.swift
//  EatsOkay
//
//  Created by LCH on 6/6/25.
//

import Foundation
import RxSwift
import ReactorKit

final class LocationSelectReactor: Reactor {
    
    var disposeBag = DisposeBag()
    var initialState: State
    
    init() {
        self.initialState = State(
            pcikerViewData: [],
            selectedItem: (0, 0)
        )
    }
    
    enum Action {
        case initialFetch
        case locationButtonTapped
        case pickerViewChnaged(component: Int, row: Int)
        case nextButtonTapped
    }
    
    enum Mutation {
        case setPickerViewDataList([[String]])
        case setPickerViewInitialRows(firstRow: Int, secondRow: Int)
        case setPickerViewSelectedItem(firstRow: Int, secondRow: Int)
        case setNextView(Void?)
        case setAlret(Void?)
        case setError(Error?)
    }
    
    struct State {
        @Pulse var pcikerViewData: [[String]]
        @Pulse var pickerViewinitialRows: (firstRow: Int, secondRow: Int)?
        var selectedItem: (firstRow: Int, secondRow: Int)
        @Pulse var nextViewState: Void?
        @Pulse var alretState: Void?
        @Pulse var error: Error?
    }
}
