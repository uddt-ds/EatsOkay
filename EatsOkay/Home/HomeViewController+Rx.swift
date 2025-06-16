//
//  UIViewController+Rx.swift
//  EatsOkay
//
//  Created by Lee on 6/16/25.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: HomeViewController {
  var viewDidLoad: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
    return ControlEvent(events: source)
  }

  var viewWillAppear: ControlEvent<Bool> {
    let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
    return ControlEvent(events: source)
  }
}
