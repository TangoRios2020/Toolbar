//
//  ToolbarItem.swift
//  Toolbar
//
//  Created by Tango on 2021/8/7.
//

import UIKit
import ReactiveSwift

protocol ToolbarItemViewModelInput {
    func didTaped()
    func enableItem(with status: Bool)
    func updateItemSelected(_ state: Bool)
    
    func updateItemTitle(_ title: String)
    func updateItem(_ item: ToolbarItemProtocol)
}

protocol ToolbarItemViewModelOutput {
    var toolbarItem: ToolbarItemProtocol { get set }
    var isSelectedSignal: Signal<Bool, Never> { get }
    var enabledSignal: Signal<Bool, Never> { get }
    var titleSignal: Signal<String, Never> { get }
    var itemSignal: Signal<ToolbarItemProtocol, Never> { get }
}

protocol ToolbarItemViewModelType {
    var input: ToolbarItemViewModelInput { get }
    var output: ToolbarItemViewModelOutput { get }
}

class ToolbarItemViewModel: ToolbarItemViewModelType {
    var input: ToolbarItemViewModelInput { return self }
    var output: ToolbarItemViewModelOutput { return self }
    
    // Input
    func didTaped() {
        toolbarItem.isSelected = !(toolbarItem.isSelected ?? false)
        isSelectedProperty.value = toolbarItem.isSelected ?? false
    }
    
    func updateItemSelected(_ state: Bool) {
        isSelectedProperty.value = state
    }
    
    func enableItem(with status: Bool) {
        enabledProperty.value = status
    }
    
    func updateItemTitle(_ title: String) {
        toolbarItem.title = title
        titleProperty.value = title
    }
    
    func updateItem(_ item: ToolbarItemProtocol) {
        toolbarItem = item
        itemProperty.value = item
    }
    
    // Output
    var toolbarItem: ToolbarItemProtocol
    var isSelectedSignal: Signal<Bool, Never>
    var enabledSignal: Signal<Bool, Never>
    var titleSignal: Signal<String, Never>
    var itemSignal: Signal<ToolbarItemProtocol, Never>
    
    // Private Property
    private let isSelectedProperty = MutableProperty<Bool>(false)
    private let enabledProperty = MutableProperty<Bool>(true)
    private let titleProperty = MutableProperty<String>("")
    private let itemProperty = MutableProperty<ToolbarItemProtocol>(ToolbarItem(.back, isSelected: false))
    
    init(with toolbarItem: ToolbarItemProtocol) {
        self.toolbarItem = toolbarItem
        isSelectedSignal = isSelectedProperty.signal
        enabledSignal = enabledProperty.signal
        titleSignal = titleProperty.signal
        itemSignal = itemProperty.signal
    }

    init() {
        self.toolbarItem = ToolbarItem(.settings, isSelected: false)
        isSelectedSignal = isSelectedProperty.signal
        enabledSignal = enabledProperty.signal
        titleSignal = titleProperty.signal
        itemSignal = itemProperty.signal
    }
}

extension ToolbarItemViewModel: ToolbarItemViewModelInput {}
extension ToolbarItemViewModel: ToolbarItemViewModelOutput {}
