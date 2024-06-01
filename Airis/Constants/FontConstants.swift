import Foundation
import UIKit

public enum FontConstants {
    case h1
    case h2
    case t1
    case t2
    case t3
}

extension FontConstants {
    var value: UIFont {
        get {
            switch self {
            case .h1:
                return UIFont(name: "Thonburi", size: 20)!
            case .h2:
                return UIFont(name: "Thonburi", size: 16)!
            case .t1:
                return UIFont(name: "Thonburi", size: 16)!
            case .t2:
                return UIFont(name: "Thonburi", size: 12)!
            case .t3:
                return UIFont(name: "Thonburi", size: 10)!
            }
        }
    }
}

