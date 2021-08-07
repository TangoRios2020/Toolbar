//
//  ViewController.swift
//  Toolbar
//
//  Created by Tango on 2021/8/7.
//

import UIKit
import Anchorage
import ReactiveSwift

class ViewController: UIViewController {
    
    let toolbarView = ToolbarView()
    var timeRangeItemView = ToolbarItemView()
    var timeIntervalItemView = ToolbarItemView()
    var crosshairItemView = ToolbarItemView()
    var lineTypeItemView = ToolbarItemView()
    var indicatorItemView = ToolbarItemView()
    var settingItemView = ToolbarItemView()
    var backItemView = ToolbarItemView()
    
    var timeRangeItemViewModel = ToolbarItemViewModel()
    var timeIntervalItemViewModel = ToolbarItemViewModel()
    var crosshairItemViewModel = ToolbarItemViewModel()
    var lineTypeItemViewModel = ToolbarItemViewModel()
    var indicatorItemViewModel = ToolbarItemViewModel()
    var settingItemViewModel = ToolbarItemViewModel()
    var backItemViewModel = ToolbarItemViewModel()
    
    let disposables = CompositeDisposable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        bindVM()
        generatingDeviceOrientationNoti()
    }
    
    func generatingDeviceOrientationNoti() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }
    
    private func setupUI() {
        view.backgroundColor = .lightGray
        view.addSubview(toolbarView)
        configureToolbarDataSource()
    }
    
    private func setupLayout() {
        toolbarView.heightAnchor == 76
        toolbarView.leftAnchor == view.leftAnchor + (UIDevice.isLandscape() ? 20 : 0)
        toolbarView.rightAnchor == view.rightAnchor
        toolbarView.bottomAnchor == view.bottomAnchor - 150
    }
    
    private func configureToolbarDataSource() {
        let timeRangeItem = ToolbarItem.initWith(actionType: .timeRange, title: "1M")
        timeRangeItemViewModel = ToolbarItemViewModel(with: timeRangeItem)
        timeRangeItemView = ToolbarItemView(with: timeRangeItemViewModel)
        
        let timeIntervalItem = ToolbarItem.initWith(actionType: .interval, title: "1W")
        timeIntervalItemViewModel = ToolbarItemViewModel(with: timeIntervalItem)
        timeIntervalItemView = ToolbarItemView(with: timeIntervalItemViewModel)
        
        let crosshairItem = ToolbarItem.initWith(actionType: .interactiveTool)
        crosshairItemViewModel = ToolbarItemViewModel(with: crosshairItem)
        crosshairItemView = ToolbarItemView(with: crosshairItemViewModel)
        
        let lineTypeItem = ToolbarItem.initWith(actionType: .lineType)
        lineTypeItemViewModel = ToolbarItemViewModel(with: lineTypeItem)
        lineTypeItemView = ToolbarItemView(with: lineTypeItemViewModel)
        
        let indicatorItem = ToolbarItem.initWith(actionType: .indicators)
        indicatorItemViewModel = ToolbarItemViewModel(with: indicatorItem)
        indicatorItemView = ToolbarItemView(with: indicatorItemViewModel)
        
        let settingItem = ToolbarItem.initWith(actionType: .settings)
        settingItemViewModel = ToolbarItemViewModel(with: settingItem)
        settingItemView = ToolbarItemView(with: settingItemViewModel)
        
        let backItem = ToolbarItem.initWith(actionType: .back)
        backItemViewModel = ToolbarItemViewModel(with: backItem)
        backItemView = ToolbarItemView(with: backItemViewModel)
        
        timeRangeItemView.addTarget(self, action: #selector(clickedButton(_:)), for: .touchUpInside)
        timeIntervalItemView.addTarget(self, action: #selector(clickedButton(_:)), for: .touchUpInside)
        crosshairItemView.addTarget(self, action: #selector(clickedButton(_:)), for: .touchUpInside)
        lineTypeItemView.addTarget(self, action: #selector(clickedButton(_:)), for: .touchUpInside)
        indicatorItemView.addTarget(self, action: #selector(clickedButton(_:)), for: .touchUpInside)
        settingItemView.addTarget(self, action: #selector(clickedButton(_:)), for: .touchUpInside)
        backItemView.addTarget(self, action: #selector(clickedButton(_:)), for: .touchUpInside)
        
        updateToolbarDataSource()
    }
    
    @objc private func clickedButton(_ sender: ToolbarItemView) {
        print("item: \(sender.viewModel.output.toolbarItem.actionType)")
    }
    
    private func updateToolbarDataSource() {
        if UIDevice.visualLandscape() {
            var settingItem = settingItemView.viewModel.output.toolbarItem
            settingItem.submenuItems?.removeAll()
            settingItemView.viewModel.input.updateItem(settingItem)
            
            toolbarView.configureDataSource(left: [timeRangeItemView, timeIntervalItemView],
                                            right: [crosshairItemView, lineTypeItemView, indicatorItemView,
                                                    settingItemView, backItemView])
        } else {
            var settingItem = settingItemView.viewModel.output.toolbarItem
            let lineTypeItem = lineTypeItemView.viewModel.output.toolbarItem
            let indicatorItem = indicatorItemView.viewModel.output.toolbarItem
            settingItem.submenuItems?.removeAll()
            settingItem.submenuItems?.append(lineTypeItem)
            settingItem.submenuItems?.append(indicatorItem)
            settingItemView.viewModel.input.updateItem(settingItem)
            
            toolbarView.configureDataSource(left: [timeRangeItemView, timeIntervalItemView],
                                            right: [crosshairItemView, settingItemView, backItemView])
        }
        
    }
    
    private func bindVM() {
        disposables += NotificationCenter.default.reactive
            .notifications(forName: UIDevice.orientationDidChangeNotification)
            .observe(on: UIScheduler())
            .observeValues({ [weak self] (_) in
                guard let self = self else { return }
                if !UIDevice.isSupportedOrientation() { return }
                self.updateToolbarDataSource()
            })
    }
    
    deinit {
        disposables.dispose()
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
}

