import Foundation
import UIKit
import SnapKit

class TabsViewController: BaseViewController<TabsViewModel> {
    private let tabBarView = TabBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: "#E7E7E7", alpha: 1)
        self.view.addSubview(tabBarView)
        tabBarView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
    }
}
