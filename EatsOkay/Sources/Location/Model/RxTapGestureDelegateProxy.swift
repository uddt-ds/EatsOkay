//
//  RxTapGestureDelegateProxy.swift
//  EatsOkay
//
//  Created by LCH on 6/18/25.
//

import UIKit
import RxSwift
import RxCocoa

extension UITapGestureRecognizer: @retroactive HasDelegate {
    public typealias Delegate = UIGestureRecognizerDelegate
}

final class RxTapGestureDelegateProxy: DelegateProxy<UITapGestureRecognizer, UIGestureRecognizerDelegate>,
    DelegateProxyType, UIGestureRecognizerDelegate {
    
    weak private(set) var gestureRecognizer: UITapGestureRecognizer?
    
    init(gestureRecognizer: UITapGestureRecognizer) {
        self.gestureRecognizer = gestureRecognizer
        super.init(
            parentObject: gestureRecognizer,
            delegateProxy: RxTapGestureDelegateProxy.self
        )
    }
    
    static func registerKnownImplementations() {
        self.register { parent in
            RxTapGestureDelegateProxy(gestureRecognizer: parent)
        }
    }
}

extension Reactive where Base: UITapGestureRecognizer {
    
    var tapGestureRecognition: ControlEvent<UITapGestureRecognizer> {
        let delegate = RxTapGestureDelegateProxy.proxy(for: base)
        base.delegate = delegate
        
        let event = base.rx.event
            .map { $0 as UITapGestureRecognizer }
        
        return ControlEvent(events: event)
    }
}
