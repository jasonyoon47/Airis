import UIKit

open class MDCButton: UIButton {
    private let ripple = RippleEffectView()
    public var isUppercaseTitle = true
    
    private let disabledBgColor = UIColor(hex: "000000", alpha: 0.8)
    private let disabledTextColor = UIColor(hex: "4427FF", alpha: 1)
    private var userBgColor: UIColor?
    private var userTextColor: UIColor?
    
    override open var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = userBgColor
                setTitleColor(userTextColor, for: .normal)
            } else {
                backgroundColor = disabledBgColor
                setTitleColor(disabledTextColor, for: .normal)
            }
        }
    }
    
    override open var backgroundColor: UIColor? {
        didSet {
            if disabledBgColor != backgroundColor {
                userBgColor = backgroundColor
            }
        }
    }
    
    public init() {
        super.init(frame: .zero)
        
        ripple.isUserInteractionEnabled = false
        addSubview(ripple)
        ripple.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setRippleColor(color: UIColor) {
        ripple.rippleColor = color
    }
    
    override open func setTitle(_ title: String?, for state: UIControl.State) {
        let caps = isUppercaseTitle ? title?.uppercased() : title
        super.setTitle(caps, for: state)
    }
    
    override open func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        if state == .normal, disabledTextColor != color {
            userTextColor = color
        }
        super.setTitleColor(color, for: state)
    }
    
    open func setTitleFont(_ font: UIFont) {
        titleLabel?.font = font
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ripple.onTouchesBegan(touches: touches, event: event)
        super.touchesBegan(touches, with: event)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        ripple.onTouchesEnded(touches: touches, event: event)
        super.touchesEnded(touches, with: event)
    }
}
