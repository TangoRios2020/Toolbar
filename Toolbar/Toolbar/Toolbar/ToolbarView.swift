//
//  ToolbarView.swift
//  Toolbar
//
//  Created by Tango on 2021/8/7.
//

import UIKit
import Anchorage
import ReactiveSwift

class ToolbarView: UIView {
    
    private var leftBarButtonItems: [ToolbarItemView]? = [ToolbarItemView]()
    private var rightBarButtonItems: [ToolbarItemView]? = [ToolbarItemView]()
    private var excaptionItem: ToolbarItemProtocol?
    
    var leftStackView = UIStackView(frame: .zero)
    var rightStackView = UIStackView(frame: .zero)
    
    private struct LayoutConstant {
        static let largeButtonWidth: CGFloat = 56
        static let normalButtonWidth: CGFloat = 40
        static let leftPaddingWithNotch: CGFloat = 0
        static let leftPaddingWithoutNotch: CGFloat = 20
        static let toolbarHeight: CGFloat = 76
        static let minumSpacing: CGFloat = 20
        static let stackViewSpacing: CGFloat = 8
        static let buttonsViewAlphaNormal: CGFloat = 1.0
        static let buttonsViewAlphaWhenLoadingData: CGFloat = 0.5
    }
    
    private var rightStackviewWidth: CGFloat {
        var width: CGFloat = 0, count: CGFloat = 0
        for view in rightStackView.arrangedSubviews {
            if let item: ToolbarItemView = view as? ToolbarItemView {
                if item.isHidden { continue }
                count += 1
                switch item.viewModel.output.toolbarItem.style {
                case .singleIcon:
                    width += LayoutConstant.normalButtonWidth
                default:
                    width += LayoutConstant.largeButtonWidth
                }
            }
        }
        return width + count * LayoutConstant.stackViewSpacing
    }
    
    private var leftStackviewWidth: CGFloat {
        var width: CGFloat = 0
        for view in leftStackView.arrangedSubviews {
            if let item: ToolbarItemView = view as? ToolbarItemView {
                switch item.viewModel.output.toolbarItem.style {
                case .singleIcon:
                    width += LayoutConstant.normalButtonWidth
                default:
                    width += LayoutConstant.largeButtonWidth
                }
            }
        }
        return width + CGFloat((leftStackView.arrangedSubviews.count - 1)) * LayoutConstant.stackViewSpacing
    }
    
    private var disposables: CompositeDisposable = CompositeDisposable()
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDataSource(left: [ToolbarItemView]?, right: [ToolbarItemView]?) {
        leftBarButtonItems = left
        rightBarButtonItems = right
        
        setupHietatchy()
        setupStyle()
        setupLayout()
    }
    
    private func reloadToolbarView(_ item: ToolbarItemProtocol?) {
        if let selectedItem = item {
            for view in leftStackView.arrangedSubviews {
                if let itemView: ToolbarItemView = view as? ToolbarItemView,
                   itemView.viewModel.output.toolbarItem.actionType == selectedItem.actionType {
                    itemView.viewModel.input.updateItem(selectedItem)
                    break
                }
            }
            
            for view in rightStackView.arrangedSubviews {
                if let itemView: ToolbarItemView = view as? ToolbarItemView,
                   itemView.viewModel.output.toolbarItem.actionType == selectedItem.actionType {
                    itemView.viewModel.input.updateItem(selectedItem)
                    break
                }
            }
        } else {
            for view in leftStackView.arrangedSubviews {
                if let itemView: ToolbarItemView = view as? ToolbarItemView {
                    var item = itemView.viewModel.output.toolbarItem
                    item.isSelected = false
                    itemView.viewModel.input.updateItem(item)
                    itemView.isSelected = false
                }
            }
            
            for view in rightStackView.arrangedSubviews {
                if let itemView: ToolbarItemView = view as? ToolbarItemView {
                    var item = itemView.viewModel.output.toolbarItem
                    if item.actionType != excaptionItem?.actionType {
                        item.isSelected = false
                        itemView.viewModel.input.updateItem(item)
                        itemView.isSelected = false
                    }
                }
            }
        }
    }
    
    private func disableOtherItems(_ item: ToolbarItemProtocol?) {
        if let selectedItem = item {
            for view in leftStackView.arrangedSubviews {
                if let itemView: ToolbarItemView = view as? ToolbarItemView,
                   itemView.viewModel.output.toolbarItem.actionType != selectedItem.actionType {
                    itemView.isEnabled = false
                }
            }
            
            for view in rightStackView.arrangedSubviews {
                if let itemView: ToolbarItemView = view as? ToolbarItemView,
                   itemView.viewModel.output.toolbarItem.actionType != selectedItem.actionType {
                    if itemView.viewModel.output.toolbarItem.actionType != excaptionItem?.actionType {
                        itemView.isEnabled = false
                    } else {
                        itemView.isUserInteractionEnabled = false
                    }
                }
            }
        }
        
    }
    
    private func clearToolbarItemsState() {
        for view in leftStackView.arrangedSubviews {
            if let itemView: ToolbarItemView = view as? ToolbarItemView {
                itemView.isEnabled = true
            }
        }
        
        for view in rightStackView.arrangedSubviews {
            if let itemView: ToolbarItemView = view as? ToolbarItemView {
                if itemView.viewModel.output.toolbarItem.actionType != excaptionItem?.actionType {
                    itemView.isEnabled = true
                } else {
                    itemView.isUserInteractionEnabled = true
                }
            }
        }
        
        guard let interactiveToolBotton = self.rightStackView.arrangedSubviews.first as? ToolbarItemView else { return }
        interactiveToolBotton.viewModel.input.updateItemSelected(
            self.rightBarButtonItems?.first?.viewModel.output.toolbarItem.isSelected ?? false)
    }
    
    private func setupHietatchy() {
        leftStackView.removeFromSuperview()
        rightStackView.removeFromSuperview()
        
        leftStackView = UIStackView(arrangedSubviews: leftBarButtonItems ?? [])
        leftStackView.alignment = .center
        leftStackView.axis = .horizontal
        leftStackView.spacing = LayoutConstant.stackViewSpacing
        leftStackView.distribution = .equalSpacing
        
        rightStackView = UIStackView(arrangedSubviews: rightBarButtonItems ?? [])
        rightStackView.alignment = .center
        rightStackView.axis = .horizontal
        rightStackView.spacing = LayoutConstant.stackViewSpacing
        rightStackView.distribution = .equalSpacing
        
        addSubview(leftStackView)
        addSubview(rightStackView)
    }
    
    private func setupStyle() {
        backgroundColor = .white
    }
    
    private func setupLayout() {
        heightAnchor == LayoutConstant.toolbarHeight
        leftStackView.heightAnchor == LayoutConstant.toolbarHeight
        leftStackView.leadingAnchor == leadingAnchor + LayoutConstant.minumSpacing
        leftStackView.centerYAnchor == centerYAnchor
        leftStackView.widthAnchor == leftStackviewWidth

        rightStackView.heightAnchor == LayoutConstant.toolbarHeight
        rightStackView.trailingAnchor == trailingAnchor - LayoutConstant.minumSpacing
        rightStackView.centerYAnchor == centerYAnchor
        rightStackView.widthAnchor == rightStackviewWidth
    }
    
}

