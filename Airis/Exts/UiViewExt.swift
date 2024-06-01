import Foundation
import UIKit

extension UIView {
    func setupLayerSettings() {
        layer.cornerRadius = 20
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 4, height: 4)
    }
}
