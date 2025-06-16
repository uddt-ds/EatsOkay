//
//  PickerViewAdapter.swift
//  EatsOkay
//
//  Created by LCH on 6/16/25.
//

import UIKit
import RxSwift
import RxCocoa

final class PickerViewAdapter: NSObject,
                                   UIPickerViewDataSource,
                                   UIPickerViewDelegate,
                                   RxPickerViewDataSourceType,
                                   SectionedViewDataSourceType {
    
    typealias Element = [[CustomStringConvertible]]
    private var items: [[CustomStringConvertible]] = []

    func model(at indexPath: IndexPath) throws -> Any {
        items[indexPath.section][indexPath.row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        items[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = items[component][row].description
        
        label.textColor = .customColor(hexCode: .neutral950)
        label.font = .customFontForButton(weight: .w900)
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, observedEvent: Event<Element>) {
        Binder(self) { (adapter, items) in
            adapter.items = items
            pickerView.reloadAllComponents()
        }.on(observedEvent)
    }
}
