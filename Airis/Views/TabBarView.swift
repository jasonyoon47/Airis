import Foundation
import UIKit

protocol TabBarViewDelegate: AnyObject {
    func onTabSelected(tabItem: TabItem)
}

class TabBarView: UIView {
    private var tabViews: [TabItem : TabView] = [:]
    
    private let stack = UIStackView()
    private var currentTab: TabItem = .create
    
    weak var delegate: TabBarViewDelegate?
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let width = UIScreen.main.bounds.width - SpacingConstants.tabBarHorizontalMargin.rawValue * 2
        stack.axis = .horizontal
        stack.setupLayerSettings()
        stack.layer.cornerRadius = 30
        stack.backgroundColor = .white
        
        let widthForEachItem = width / CGFloat(TabItem.allCases.count)
        for tab in TabItem.allCases {
            let tabView = TabView(tab: tab)
            tabView.delegate = self
            tabView.snp.makeConstraints { make in
                make.width.equalTo(widthForEachItem)
            }
            tabViews[tab] = tabView
            stack.addArrangedSubview(tabView)
        }
        
        tabViews[currentTab]?.select()
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension TabBarView: TabsViewDelegate {
    func onTabClicked(tab: TabItem) {
        tabViews[currentTab]?.deselect()
        currentTab = tab
        delegate?.onTabSelected(tabItem: tab)
    }
}

protocol TabsViewDelegate: AnyObject {
    func onTabClicked(tab: TabItem)
}

class TabView: UIView {
    private let containerView = UIView()
    private let textView = UILabel()
    private let iconView = UIImageView()
    private let btnAction = MDCButton()
    private let tab: TabItem
    weak var delegate: TabsViewDelegate?

    init(tab: TabItem) {
        self.tab = tab
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let contentView = UIView()
        iconView.image = tab.image()
        iconView.tintColor = ColorConstants.tabDeselected.value
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        textView.text = tab.text()
        textView.font = FontConstants.t2.value
        textView.textColor = ColorConstants.tabDeselected.value
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(iconView.snp.bottom)
        }
        
        btnAction.addTarget(self, action: #selector(onBtnClicked), for: .touchUpInside)
        contentView.addSubview(btnAction)
        btnAction.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func onBtnClicked(button: UIButton) {
        select()
        delegate?.onTabClicked(tab: tab)
    }
    
    func select() {
        iconView.tintColor = ColorConstants.tabSelected.value
        textView.textColor = ColorConstants.tabSelected.value
    }
    
    func deselect() {
        iconView.tintColor = ColorConstants.tabDeselected.value
        textView.textColor = ColorConstants.tabDeselected.value
    }
}

enum TabItem: CaseIterable {
    case create
    case filter
    case discover
    case profile
    
    func image(selected: Bool = false) -> UIImage {
        switch self {
        case .create:
            return UIImage(systemName: "plus.square")!
        case .filter:
            return UIImage(systemName: "photo")!
        case .discover:
            return UIImage(systemName: "safari")!
        case .profile:
            return UIImage(systemName: "person")!
        }
    }
    
    func text() -> String {
        switch self {
        case .create:
            return "Create"
        case .filter:
            return "AI Filter"
        case .discover:
            return "Discover"
        case .profile:
            return "Profile"
        }
    }
    
    func vc() -> UIViewController {
        switch self {
        case .create:
            return MainViewController()
        case .filter:
            return DiscoverViewController()
        case .discover:
            return MainViewController()
        case .profile:
            return DiscoverViewController()
        }
    }
}
