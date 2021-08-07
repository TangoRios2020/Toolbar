//
//  ToolbarViewModel.swift
//  Toolbar
//
//  Created by Tango on 2021/8/7.
//

import UIKit
import ReactiveSwift

public enum ChartToolbarActionType {
    case interval
    case timeRange
    case interactiveTool
    case lineType
    case indicators
    case settings
    case back
}

public protocol ToolbarItemProtocol {
    var icon: UIImage? { get set }
    var title: String? { get set }
    var isSelected: Bool? { get set }
    var actionType: ChartToolbarActionType { get set }
    var style: ToolbarItemStyle { get set }
    var submenuItems: [ToolbarItemProtocol]? { get set }
}

public enum ToolbarItemStyle {
    case singleIcon
    case iconWithArrow
    case titleWithArrow
}

public struct ToolbarItem: ToolbarItemProtocol {
    public var icon: UIImage?
    public var title: String?
    public var actionType: ChartToolbarActionType
    public var style: ToolbarItemStyle
    public var isSelected: Bool?
    public var submenuItems: [ToolbarItemProtocol]?
    
    init(icon: UIImage?,
         title: String?,
         style: ToolbarItemStyle = .singleIcon,
         actionType: ChartToolbarActionType,
         isSelected: Bool? = false,
         submenuItems: [ToolbarItemProtocol]? = []) {
        self.icon = icon
        self.title = title
        self.actionType = actionType
        self.style = style
        self.isSelected = isSelected
        self.submenuItems = submenuItems
    }
    
    init(_ actionType: ChartToolbarActionType,
         isSelected: Bool?) {
        self.init(icon: nil, title: nil, style: .singleIcon, actionType: actionType, isSelected: isSelected)
    }
}

extension ToolbarItem {
    enum IconName: String {
        case chartAim, chartAnalysis, chartMarkets, chartMore, chartBack
    }
    
    static func initWith(actionType: ChartToolbarActionType, title: String? = nil) -> ToolbarItem {
        switch actionType {
        case .timeRange:
            return ToolbarItem(icon: nil,
                               title: title,
                               style: .titleWithArrow,
                               actionType: .timeRange)
        case .interval:
            return ToolbarItem(icon: nil,
                               title: title,
                               style: .titleWithArrow,
                               actionType: .interval)
        case .interactiveTool:
            return  ToolbarItem(icon: UIImage(named: IconName.chartAim.rawValue),
                                title: nil,
                                style: .singleIcon,
                                actionType: .interactiveTool)
        case .lineType:
            return ToolbarItem(icon: UIImage(named: IconName.chartAnalysis.rawValue),
                               title: nil,
                               style: .iconWithArrow,
                               actionType: .lineType)
        case .indicators:
            return  ToolbarItem(icon: UIImage(named: IconName.chartMarkets.rawValue),
                                title: nil,
                                style: .iconWithArrow,
                                actionType: .indicators)
        case .settings:
            return ToolbarItem(icon: UIImage(named: IconName.chartMore.rawValue),
                               title: nil,
                               style: .singleIcon,
                               actionType: .settings)
        case .back:
            return ToolbarItem(icon: UIImage(named: IconName.chartBack.rawValue),
                               title: nil,
                               style: .singleIcon,
                               actionType: .back)
        }
    }
}

public protocol ToolbarViewModelType {
    var input: ToolbarViewModelInput { get }
    var output: ToolbarViewModelOutput { get }
}

public protocol ToolbarViewModelInput {
    func didTappedItem(_ item: ToolbarItem?)
    func orientationDidChanged()
    func enableAllItems()
    func disableOtherItems()
    func extraItemSelected(_ item: ToolbarItem?)
}

public protocol ToolbarViewModelOutput {
    var presentToolMenuSignal: Signal<ChartToolbarActionType, Never> { get }
    var closeToolMenuSignal: Signal<Void, Never> { get }
    var selectedItemSignal: Signal<ToolbarItemProtocol?, Never> { get }
    var orientationChangedSignal: Signal<Void, Never> { get }
    var enableAllItemsSignal: Signal<Void, Never> { get }
    var disableOtherItemsSignal: Signal<ToolbarItemProtocol?, Never> { get }
    var extraItemSelectedSignal: Signal<ToolbarItemProtocol?, Never> { get }
    
    var selectedItemProperty: MutableProperty<ToolbarItemProtocol?> { get }
}

class ToolbarViewModel: ToolbarViewModelType {
    var input: ToolbarViewModelInput { return self }
    var output: ToolbarViewModelOutput { return self }
    
    // MARK: ToolbarViewModelOutput
    var presentToolMenuSignal: Signal<ChartToolbarActionType, Never>
    var closeToolMenuSignal: Signal<Void, Never>
    var selectedItemSignal: Signal<ToolbarItemProtocol?, Never>
    var orientationChangedSignal: Signal<Void, Never>
    var enableAllItemsSignal: Signal<Void, Never>
    var disableOtherItemsSignal: Signal<ToolbarItemProtocol?, Never>
    var extraItemSelectedSignal: Signal<ToolbarItemProtocol?, Never>
    
    var selectedItemProperty = MutableProperty<ToolbarItemProtocol?>(nil)

    // MARK: Private property
    private var presentToolMenuProperty = MutableProperty<ChartToolbarActionType>(.interval)
    private var closeToolMenuProperty = MutableProperty<Void>(())
    private var orientationChangedProperty = MutableProperty<Void>(())
    private var enableAllItemsProperty = MutableProperty<Void>(())
    private var disableOtherItemsProperty = MutableProperty<ToolbarItemProtocol?>(nil)
    private var extraItemSelectedProperty = MutableProperty<ToolbarItemProtocol?>(nil)

    init() {
        presentToolMenuSignal = presentToolMenuProperty.signal
        closeToolMenuSignal = closeToolMenuProperty.signal
        selectedItemSignal = selectedItemProperty.signal
        orientationChangedSignal = orientationChangedProperty.signal
        enableAllItemsSignal = enableAllItemsProperty.signal
        disableOtherItemsSignal = disableOtherItemsProperty.signal
        extraItemSelectedSignal = extraItemSelectedProperty.signal
    }
    
}

extension ToolbarViewModel: ToolbarViewModelInput {
    func didTappedItem(_ item: ToolbarItem?) {
        selectedItemProperty.value = item
    }
    
    func orientationDidChanged() {
        orientationChangedProperty.value = ()
    }
    
    func enableAllItems() {
        enableAllItemsProperty.value = ()
    }
    
    func disableOtherItems() {
        disableOtherItemsProperty.value = selectedItemProperty.value
    }
    
    func extraItemSelected(_ item: ToolbarItem?) {
        extraItemSelectedProperty.value = item
    }

}
extension ToolbarViewModel: ToolbarViewModelOutput {}

