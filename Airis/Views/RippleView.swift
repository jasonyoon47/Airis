import Foundation
import UIKit

public protocol RippleViewDelegate: AnyObject {
  func onTapAction(rippleView: RippleView)
}

// Reference: https://github.com/maurodec/SimpleRipple/blob/master/SimpleRipple/UIView%2BSimpleRipple.m
open class RippleView: UIView {
  public var customId = ""
  public var isRippleEnabled = true
  public var isTapEnabled = true
  private let materialRipple = RippleEffectView()
  public weak var rippleViewDelegate: RippleViewDelegate?

  public init() {
    super.init(frame: .zero)
    setupView(ripple: materialRipple)
  }

  public required init?(coder: NSCoder) {
      super.init(coder: coder)
  }

  open func setupView(ripple _: RippleEffectView) {}

  override public func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)
    materialRipple.removeRipple()
  }

  override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if isRippleEnabled {
      materialRipple.onTouchesBegan(touches: touches, event: event)
    }

    super.touchesBegan(touches, with: event)
  }

  override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    if isRippleEnabled {
      materialRipple.onTouchesCancelled(touches: touches, event: event)
    }

    super.touchesCancelled(touches, with: event)
  }

  override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if isRippleEnabled {
      materialRipple.onTouchesEnded(touches: touches, event: event)
    }

    super.touchesEnded(touches, with: event)

    if isTapEnabled {
      rippleViewDelegate?.onTapAction(rippleView: self)
    }
  }
}

open class RippleTest: RippleView {
  override open func setupView(ripple: RippleEffectView) {
    addSubview(ripple)
    ripple.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}

open class RippleEffectView: UIView {
  enum RippleState {
    case none
    case rippling
    case ripplingEnded
    case ripplingNeedsEnd
  }

  private let fadeDuration = 0.25
  private weak var rippleLayer: CAShapeLayer?
  private var state = RippleState.none
    var rippleColor: UIColor = UIColor(white:0, alpha: 0.12)

  open func onTouchesBegan(touches: Set<UITouch>, event _: UIEvent?) {
    if let origin = touches.first?.location(in: self), state == .none {
      state = .rippling
      rippleDefault(origin: origin)
    }
  }

  open func onTouchesCancelled(touches _: Set<UITouch>, event _: UIEvent?) {
    removeRipple()
  }

  open func onTouchesEnded(touches _: Set<UITouch>, event _: UIEvent?) {
    switch state {
    case .rippling:
      state = .ripplingNeedsEnd
    case .ripplingEnded:
      rippleAway()
    default:
      break
    }
  }

  private func rippleAway() {
    animateRippleAway()
    DispatchQueue.main.asyncAfter(deadline: .now() + fadeDuration) {
      self.removeRipple()
    }
  }

  private func rippleDefault(origin: CGPoint) {
    rippleStartingAt(origin: origin, color: rippleColor, duration: 0.2)
  }

  private func distanceBetween(a: CGPoint, b: CGPoint) -> CGFloat {
    return sqrt(pow(abs(a.x - b.x), 2) + pow(abs(a.y - b.y), 2))
  }

  func rippleStartingAt(origin: CGPoint, color: UIColor, duration: TimeInterval) {
    let bounds = self.bounds
    let x = bounds.width
    let y = bounds.height

    let corners = [CGPoint.zero, CGPoint(x: 0, y: y), CGPoint(x: x, y: 0), CGPoint(x: x, y: y)]

    var minDistance = CGFloat.greatestFiniteMagnitude
    var maxDistance: CGFloat = -1

    for corner in corners {
      let d = distanceBetween(a: origin, b: corner)
      if d < minDistance {
        minDistance = d
      }
      if d > maxDistance {
        maxDistance = d
      }
    }

    let startRadius: CGFloat = 0.1
    let endRadius: CGFloat = maxDistance

    let startPath = UIBezierPath(arcCenter: origin, radius: startRadius, startAngle: 0, endAngle: Double.pi * 2, clockwise: true)

    let endPath = UIBezierPath(arcCenter: origin, radius: endRadius, startAngle: 0, endAngle: Double.pi * 2, clockwise: true)

    let rippleLayer = CAShapeLayer()

    layer.masksToBounds = true
    rippleLayer.fillColor = color.cgColor

    let rippleAnimation = CABasicAnimation(keyPath: "path")
    rippleAnimation.fillMode = CAMediaTimingFillMode.both
    rippleAnimation.duration = duration
    rippleAnimation.fromValue = startPath.cgPath
    rippleAnimation.toValue = endPath.cgPath
    rippleAnimation.isRemovedOnCompletion = false
    rippleAnimation.delegate = self
    rippleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

    let fadeAnimationIn = CABasicAnimation(keyPath: "opacity")
    fadeAnimationIn.fillMode = CAMediaTimingFillMode.both
    fadeAnimationIn.duration = duration
    fadeAnimationIn.fromValue = 0
    fadeAnimationIn.toValue = 1
    fadeAnimationIn.isRemovedOnCompletion = false
    rippleLayer.add(fadeAnimationIn, forKey: nil)

    layer.addSublayer(rippleLayer)
    rippleLayer.add(rippleAnimation, forKey: nil)

    self.rippleLayer = rippleLayer
  }

  private func animateRippleAway() {
    let fadeAnimation = CABasicAnimation(keyPath: "opacity")
    fadeAnimation.fillMode = CAMediaTimingFillMode.both
    fadeAnimation.duration = fadeDuration
    fadeAnimation.fromValue = 1
    fadeAnimation.toValue = 0
    fadeAnimation.isRemovedOnCompletion = false
    rippleLayer?.add(fadeAnimation, forKey: nil)
  }

  func removeRipple() {
    rippleLayer?.removeAllAnimations()
    rippleLayer?.removeFromSuperlayer()
    rippleLayer = nil
    state = .none
  }
}

extension RippleEffectView: CAAnimationDelegate {
  public func animationDidStop(_: CAAnimation, finished _: Bool) {
    switch state {
    case .ripplingNeedsEnd:
      rippleAway()
    case .rippling:
      state = .ripplingEnded
    default:
      break
    }
  }
}
