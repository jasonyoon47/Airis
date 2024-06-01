import Foundation
import UIKit

public enum ColorConstants {    
    case tabSelected
    case tabDeselected
    case mainBackground
    case primaryAccent
}

extension ColorConstants {
    var value: UIColor {
        get {
            switch self {
            case .tabSelected:
                return UIColor(hex: "#4427FF", alpha: 1)!
            case.tabDeselected:
                return UIColor(hex: "#000000", alpha: 0.6)!
            case.mainBackground:
                return UIColor(hex: "#E7E7E7", alpha: 1)!
            case.primaryAccent:
                return UIColor(hex: "#4527FF", alpha: 1)!
            }
        }
    }
}

