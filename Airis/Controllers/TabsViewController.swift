import Foundation
import UIKit
import SnapKit

class TabsViewController: BaseViewController<TabsViewModel> {
    private let tabBarView = TabBarView()
    private let childContainer = UIView()
    private var tabsCache: [TabItem: UIViewController] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: "#E7E7E7", alpha: 1)
        tabBarView.delegate = self
        self.view.addSubview(tabBarView)
        tabBarView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        self.view.addSubview(childContainer)
        let topSafeArea: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        childContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(topSafeArea)
            make.bottom.equalTo(tabBarView.snp.top).offset(4)
        }
        
        onTabSelected(tabItem: .create)
    }
    
    private func getTabVc(tabItem: TabItem) -> UIViewController {
        if let tab = tabsCache[tabItem] {
            return tab
        } else {
            let vc = tabItem.vc()
            tabsCache[tabItem] = vc
            return vc
        }
    }
    
    private func showTabVc(vc: UIViewController) {
        removeKids()
        addChild(vc)
        vc.view.frame = childContainer.bounds
        childContainer.addSubview(vc.view)
        vc.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension TabsViewController: TabBarViewDelegate {
    func onTabSelected(tabItem: TabItem) {
        let vc = getTabVc(tabItem: tabItem)
        showTabVc(vc: vc)
    }
}
