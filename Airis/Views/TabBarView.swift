import Foundation
import UIKit

class TabBarView: UIView {
    private let tabs: [TabsItem] = [
        TabsItem(title: "Create", image: UIImage(systemName: "plus.square"), tag: 0, viewController: MainViewController()),
        TabsItem(title: "AI Filter", image: UIImage(systemName: "photo"), tag: 1, viewController: DiscoverViewController()),
        TabsItem(title: "Discover", image: UIImage(systemName: "safari"), tag: 2, viewController: MainViewController()),
        TabsItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3, viewController: DiscoverViewController()),
    ]
    
    private var tabViews: [TabView] = []
    
    private let stack = UIStackView()
    private var currentTabTag = 0
    
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
        
        let widthForEachItem = width / CGFloat(tabs.count)
        for tab in tabs {
            let tabView = TabView(tab: tab)
            tabView.delegate = self
            tabView.snp.makeConstraints { make in
                make.width.equalTo(widthForEachItem)
            }
            tabViews.append(tabView)
            stack.addArrangedSubview(tabView)
        }
        
        tabViews[0].select()
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension TabBarView: TabsViewDelegate {
    func onTabClicked(tag: Int) {
        tabViews[currentTabTag].deselect()
        tabViews[tag].select()
        currentTabTag = tag
    }
}

// separate class

protocol TabsViewDelegate: AnyObject {
    func onTabClicked(tag: Int)
}

class TabView: UIView {
    let containerView = UIView()
    let textView = UILabel()
    let iconView = UIImageView()
    let btnAction = MDCButton()
    weak var delegate: TabsViewDelegate?

    init(tab: TabsItem) {
        super.init(frame: .zero)
        setupView(tab: tab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(tab: TabsItem) {
        let contentView = UIView()
        iconView.image = tab.image
        iconView.tintColor = ColorConstants.tabDeselected.value
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        textView.text = tab.title
        textView.font = FontConstants.t2.value
        textView.textColor = ColorConstants.tabDeselected.value
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(iconView.snp.bottom)
        }
        
        btnAction.addTarget(self, action: #selector(onBtnClicked), for: .touchUpInside)
        btnAction.tag = tab.tag
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
        delegate?.onTabClicked(tag: button.tag)
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

class TabsItem {
    let title: String
    let image: UIImage?
    let tag: Int
    private let viewController: UIViewController
    
    init(title: String, image: UIImage?, tag: Int, viewController: UIViewController) {
        self.title = title
        self.image = image
        self.tag = tag
        self.viewController = viewController
    }
}

