//
//  RxPanGestureDelegateProxy.swift
//  EatsOkay
//
//  Created by LCH on 6/18/25.
//

import UIKit
import RxSwift
import RxCocoa

extension UIPanGestureRecognizer: @retroactive HasDelegate {
    public typealias Delegate = UIGestureRecognizerDelegate
}

final class RxPanGestureDelegateProxy: DelegateProxy<UIPanGestureRecognizer, UIGestureRecognizerDelegate>,
    DelegateProxyType, UIGestureRecognizerDelegate {
    
    weak private(set) var gestureRecognizer: UIPanGestureRecognizer?
    
    init(gestureRecognizer: UIPanGestureRecognizer) {
        self.gestureRecognizer = gestureRecognizer
        super.init(
            parentObject: gestureRecognizer,
            delegateProxy: RxPanGestureDelegateProxy.self
        )
    }
    
    static func registerKnownImplementations() {
        self.register { parent in
            RxPanGestureDelegateProxy(gestureRecognizer: parent)
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        
        let velocity = panGesture.velocity(in: panGesture.view)
        
        if abs(velocity.y) > 50 {
            return true
        } else {
            return false
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension Reactive where Base: UIPanGestureRecognizer {
    
    var panGestureWithSimultaneousRecognition: ControlEvent<UIPanGestureRecognizer> {
        let delegate = RxPanGestureDelegateProxy.proxy(for: base)
        base.delegate = delegate
        
        let event = base.rx.event
            .map { $0 as UIPanGestureRecognizer }
        
        return ControlEvent(events: event)
    }
}
