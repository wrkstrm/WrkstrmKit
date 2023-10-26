import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit

struct InterpolatingView: UIViewRepresentable {

  static var hackerOrange = Color(red: 255.0, green: 102.0, blue: 0.0, opacity: 1)

  var color: Color

  var radius: CGFloat

  var x: CGFloat

  var y: CGFloat

  func makeUIView(context _: Context) -> InterpolatingUIView {
    let view: InterpolatingUIView = .init(frame: .zero)
    view.color = color
    view.radius = radius
    view.x = x
    view.y = y
    return view
  }

  func updateUIView(_: InterpolatingUIView, context _: Context) {}
}

extension InterpolatingView {

  func makeCoordinator() -> InterpolatingView.Coordinator {
    Coordinator(self)
  }

  class Coordinator {

    var view: InterpolatingView

    init(_ view: InterpolatingView) {
      self.view = view
    }
  }
}

class InterpolatingUIView: UILabel {

  var color: Color = .black

  var radius: CGFloat = 0

  var x: CGFloat = 1

  var y: CGFloat = 1

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  func commonInit() {
    backgroundColor = .clear
    createShadowEffect()
  }

  func createShadowEffect() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: x, height: y)
    layer.shadowOpacity = 1.0
    layer.shadowRadius = radius
    let horizontal = UIInterpolatingMotionEffect(
      keyPath: "layer.shadowOffset.width",
      type: .tiltAlongHorizontalAxis)
    horizontal.minimumRelativeValue = -12
    horizontal.maximumRelativeValue = 12

    let vertical = UIInterpolatingMotionEffect(
      keyPath: "layer.shadowOffset.height",
      type: .tiltAlongVerticalAxis)
    vertical.minimumRelativeValue = -12
    vertical.maximumRelativeValue = 14

    addMotionEffect(horizontal)
    addMotionEffect(vertical)
  }
}
#endif  // canImport(UIKit)
