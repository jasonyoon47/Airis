import Foundation
import UIKit

public protocol ViewModel: AnyObject {
    init()
}

open class BaseViewController<VM: ViewModel>: UIViewController {
    public let viewModel: VM
    
    public init() {
        viewModel = VM()
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        for child in self.children {
            child.removeKidSelf()
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIViewController {
    func removeKids() {
        for kid in children {
            kid.removeKidSelf()
        }
    }
    
    func removeKidSelf() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
