//
//  File.swift
//  Toolbar
//
//  Created by Tango on 2021/8/7.
//

import UIKit
import Anchorage
import ReactiveSwift

class ToolbarItemView: UIButton {
    private struct UISettingConstant {
        static let buttonHeight: CGFloat = 40
        static let largeButtonWidth: CGFloat = 56
        static let normalButtonWidth: CGFloat = 40
        static let buttonMargin: CGFloat = 4
        static let backButtonRightMargin: CGFloat = 16
        static let arrowWidth: CGFloat = 32
        static let buttonCornerRadius: CGFloat = 2
        static let buttonBorderWidth: CGFloat = 1
        
        static let normalIconWidth: CGFloat = 24
        static let largeIconWidth: CGFloat = 32
        
        static let leftPadding: CGFloat = 42
        static let rightPadding: CGFloat = 15
        static let disableAlpha: CGFloat = 0.5
        static let enableAlpha: CGFloat = 1
        
        static let selectedColor = UIColor.red
        static let disabledColor = UIColor.gray
        
        static let borderColor = UIColor.blue
        static let borderSelectColor = UIColor.blue
        static let selectedBackgroundColor = UIColor.blue
        static let normalBackgroundColor = UIColor.white
    }

    var viewModel: ToolbarItemViewModelType
    private var disposables = CompositeDisposable()

    private lazy var arrow: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.setImage(UIImage(named: "chartArrow"), for: .normal)
        button.setImage(UIImage(named: "chartArrowSelect"), for: .selected)
        button.setImage(UIImage(named: "chartArrow")?.withTintColor(UISettingConstant.disabledColor), for: .disabled)
        return button
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = UISettingConstant.selectedBackgroundColor
                self.layer.borderColor = UISettingConstant.borderSelectColor
                    .resolvedColor(with: traitCollection).cgColor
            } else {
                self.backgroundColor = UISettingConstant.normalBackgroundColor
                self.layer.borderColor = UISettingConstant.borderColor.resolvedColor(with: traitCollection).cgColor
            }
            if self.subviews.contains(arrow) {
                arrow.isSelected = isSelected
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = UISettingConstant.normalBackgroundColor
                self.layer.borderColor = UISettingConstant.borderSelectColor
                    .resolvedColor(with: traitCollection).cgColor
            } else {
                self.backgroundColor = UISettingConstant.normalBackgroundColor
                self.layer.borderColor = UISettingConstant.borderColor.resolvedColor(with: traitCollection).cgColor
            }
            if self.subviews.contains(arrow) {
                arrow.isEnabled = isEnabled
            }
        }
    }
    
    init() {
        let toolbarItem = ToolbarItem(icon: nil, title: nil, actionType: .back)
        self.viewModel = ToolbarItemViewModel(with: toolbarItem)
        super.init(frame: .zero)
    }
    
    init(with viewModel: ToolbarItemViewModelType) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureUI()
        configureLayout()
        configureViewModel()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        let toolbarItem = viewModel.output.toolbarItem
        switch toolbarItem.style {
        case .singleIcon:
            self.setImage(toolbarItem.icon, for: .normal)
            self.setImage(toolbarItem.icon?.withTintColor(UISettingConstant.selectedColor), for: .selected)
        case .iconWithArrow:
            addSubview(arrow)
            self.setImage(toolbarItem.icon, for: .normal)
            self.setImage(toolbarItem.icon?.withTintColor(UISettingConstant.disabledColor), for: .disabled)
            self.setImage(toolbarItem.icon?.withTintColor(UISettingConstant.selectedColor), for: .selected)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        case .titleWithArrow:
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 42, bottom: 0, right: 0)
            self.setTitleColor(UISettingConstant.selectedColor, for: .selected)
            self.setTitleColor(UISettingConstant.disabledColor, for: .disabled)
            self.setImage(UIImage(named: "chartArrow"), for: .normal)
            self.setImage(UIImage(named: "chartArrow")?.withTintColor(UISettingConstant.disabledColor), for: .disabled)
            self.setImage(UIImage(named: "chartArrowSelect"), for: .selected)
            self.titleLabel?.adjustsFontSizeToFitWidth = true
            self.setTitle(toolbarItem.title, for: .normal)
        }
        configureButtonStyle()
    }
    
    private func configureLayout() {
        let toolbarItem = viewModel.output.toolbarItem
        switch toolbarItem.style {
        case .singleIcon:
            widthAnchor == UISettingConstant.normalButtonWidth
            heightAnchor == UISettingConstant.buttonHeight
        case .iconWithArrow:
            widthAnchor == UISettingConstant.largeButtonWidth
            heightAnchor == UISettingConstant.buttonHeight
            arrow.widthAnchor == UISettingConstant.normalIconWidth
            arrow.heightAnchor == heightAnchor
            arrow.centerYAnchor == centerYAnchor
            arrow.trailingAnchor == trailingAnchor
        case .titleWithArrow:
            widthAnchor == UISettingConstant.largeButtonWidth
            heightAnchor == UISettingConstant.buttonHeight
        }
    }
    
    private func configureButtonStyle() {
        self.isSelected = viewModel.output.toolbarItem.isSelected ?? false
        self.layer.borderWidth = UISettingConstant.buttonBorderWidth
        self.layer.cornerRadius = UISettingConstant.buttonCornerRadius
        self.backgroundColor = .gray
        self.layer.borderColor = UIColor.gray.cgColor
        self.titleLabel?.font = UIFont(name: "", size: 16)
        self.setTitleColor(UIColor.black, for: .normal)
    }
    
    private func configureViewModel() {
        
    }
    
    private func updateSingleView(_ item: ToolbarItemProtocol) {
        switch item.actionType {
        case .lineType:
            guard let image = item.icon else { return }
            self.setImage(image, for: .normal)
            self.setImage(image.withTintColor(UISettingConstant.selectedColor), for: .selected)
            self.isSelected = item.isSelected ?? false
        case .interval:
            guard let title = item.title else { return }
            self.setTitle(title, for: .normal)
            self.isSelected = item.isSelected ?? false
        case .timeRange:
            guard let title = item.title else { return }
            self.setTitle(title, for: .normal)
            self.isSelected = item.isSelected ?? false
        case .interactiveTool, .settings, .indicators:
            guard let isSelected = item.isSelected else { return }
            self.isSelected = isSelected
        default:
            break
        }
    }
    
}

