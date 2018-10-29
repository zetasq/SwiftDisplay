//
//  LayoutElementStyle.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/9.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

protocol LayoutElementStyleDelegate: AnyObject {
  func layoutElementStyle(_ style: LayoutElementStyle, propertyDidChange perperty: LayoutElementStyle.Property)
}


class LayoutElementStyle {
  
  enum Property {
    case width
    case minWidth
    case maxWidth
    
    case height
    case minHeight
    case maxHeight
    
    case spacingBefore
    case spacingAfter
    case flexGrow
    case flexShrink
    case flexBasis
    case alignSelf
    case ascender
    case descender
    
    case layoutPosition
  }
  
  /**
   * @abstract The object that acts as the delegate of the style.
   *
   * @discussion The delegate must adopt the ASLayoutElementStyleDelegate protocol. The delegate is not retained.
   */
  private(set) weak var delegate: LayoutElementStyleDelegate?
  
  /**
   * @abstract A size constraint that should apply to this ASLayoutElement.
   */
  private(set) var size: LayoutElementSize {
    get {
      return _size.value
    }
    set {
      _instance_lock.withCriticalScope {
        _size.value = newValue
      }
      // No CallDelegate method as ASLayoutElementSize is currently internal.
    }
  }
  
  /**
   * @abstract The width property specifies the width of the content area of an ASLayoutElement.
   * The minWidth and maxWidth properties override width.
   * Defaults to ASDimensionAuto
   */
  var width: Dimension {
    get {
      return _size.value.width
    }
    set {
      _instance_lock.withCriticalScope {
        _size.value.width = newValue
      }
      delegate?.layoutElementStyle(self, propertyDidChange: .width)
    }
  }
  
  /**
   * @abstract The minWidth property is used to set the minimum width of a given element. It prevents the used value of
   * the width property from becoming smaller than the value specified for minWidth.
   * The value of minWidth overrides both maxWidth and width.
   * Defaults to ASDimensionAuto
   */
  var minWidth: Dimension {
    get {
      return _size.value.minWidth
    }
    set {
      _instance_lock.withCriticalScope {
        _size.value.minWidth = newValue
      }
      delegate?.layoutElementStyle(self, propertyDidChange: .minWidth)
    }
  }
  
  /**
   * @abstract The maxWidth property is used to set the maximum width of a given element. It prevents the used value of
   * the width property from becoming larger than the value specified for maxWidth.
   * The value of maxWidth overrides width, but minWidth overrides maxWidth.
   * Defaults to ASDimensionAuto
   */
  var maxWidth: Dimension {
    get {
      return _size.value.maxWidth
    }
    set {
      _instance_lock.withCriticalScope {
        _size.value.maxWidth = newValue
      }
      delegate?.layoutElementStyle(self, propertyDidChange: .maxWidth)
    }
  }
  /**
   * @abstract The height property specifies the height of the content area of an ASLayoutElement
   * The minHeight and maxHeight properties override height.
   * Defaults to ASDimensionAuto
   */
  var height: Dimension {
    get {
      return _size.value.height
    }
    set {
      _instance_lock.withCriticalScope {
        _size.value.height = newValue
      }
      delegate?.layoutElementStyle(self, propertyDidChange: .height)
    }
  }
  
  /**
   * @abstract The minHeight property is used to set the minimum height of a given element. It prevents the used value
   * of the height property from becoming smaller than the value specified for minHeight.
   * The value of minHeight overrides both maxHeight and height.
   * Defaults to ASDimensionAuto
   */
  var minHeight: Dimension {
    get {
      return _size.value.minHeight
    }
    set {
      _instance_lock.withCriticalScope {
        _size.value.minHeight = newValue
      }
      delegate?.layoutElementStyle(self, propertyDidChange: .minHeight)
    }
  }
  
  /**
   * @abstract The maxHeight property is used to set the maximum height of an element. It prevents the used value of the
   * height property from becoming larger than the value specified for maxHeight.
   * The value of maxHeight overrides height, but minHeight overrides maxHeight.
   * Defaults to ASDimensionAuto
   */
  var maxHeight: Dimension {
    get {
      return _size.value.maxHeight
    }
    set {
      _instance_lock.withCriticalScope {
        _size.value.maxHeight = newValue
      }
      delegate?.layoutElementStyle(self, propertyDidChange: .maxHeight)
    }
  }
  
  /**
   * @abstract Provides a suggested size for a layout element. If the optional minSize or maxSize are provided,
   * and the preferredSize exceeds these, the minSize or maxSize will be enforced. If this optional value is not
   * provided, the layout element’s size will default to it’s intrinsic content size provided calculateSizeThatFits:
   *
   * @discussion This method is optional, but one of either preferredSize or preferredLayoutSize is required
   * for nodes that either have no intrinsic content size or
   * should be laid out at a different size than its intrinsic content size. For example, this property could be
   * set on an ASImageNode to display at a size different from the underlying image size.
   *
   * @warning Calling the getter when the size's width or height are relative will cause an assert.
   */
  var preferredSize: CGSize {
    get {
      let size = _size.value
      
      switch (size.width, size.height) {
      case (.proportional, _):
        assert(false, "Cannot get preferredSize of element with fractional width. Width: \(size.width.debugDescription)")
        return .zero
      case (_, .proportional):
        assert(false, "Cannot get preferredSize of element with fractional height. Height: \(size.height.debugDescription)")
        return .zero
      case (.auto, .auto):
        return .zero
      case (.fixed(let width), .auto):
        return CGSize(width: width, height: 0)
      case (.auto, .fixed(let height)):
        return CGSize(width: 0, height: height)
      case (.fixed(let width), .fixed(let height)):
        return CGSize(width: width, height: height)
      }
    }
    set {
      _instance_lock.withCriticalScope {
        var newSize = _size.value
        newSize.width = .fixed(value: newValue.width)
        newSize.height = .fixed(value: newValue.height)
        _size.value = newSize
      }
    }
  }
  
  /**
   * @abstract An optional property that provides a minimum size bound for a layout element. If provided, this restriction will
   * always be enforced. If a parent layout element’s minimum size is smaller than its child’s minimum size, the child’s
   * minimum size will be enforced and its size will extend out of the layout spec’s.
   *
   * @discussion For example, if you set a preferred relative width of 50% and a minimum width of 200 points on an
   * element in a full screen container, this would result in a width of 160 points on an iPhone screen. However,
   * since 160 pts is lower than the minimum width of 200 pts, the minimum width would be used.
   */
  var minSize: CGSize {
    @available(*, unavailable)
    get {
      fatalError()
    }
    set {
      _instance_lock.withCriticalScope {
        var newSize = _size.value
        newSize.minWidth = .fixed(value: newValue.width)
        newSize.minHeight = .fixed(value: newValue.height)
        _size.value = newSize
      }
      delegate?.layoutElementStyle(self, propertyDidChange: .minWidth)
      delegate?.layoutElementStyle(self, propertyDidChange: .minHeight)
    }
  }
  
  /**
   * @abstract An optional property that provides a maximum size bound for a layout element. If provided, this restriction will
   * always be enforced.  If a child layout element’s maximum size is smaller than its parent, the child’s maximum size will
   * be enforced and its size will extend out of the layout spec’s.
   *
   * @discussion For example, if you set a preferred relative width of 50% and a maximum width of 120 points on an
   * element in a full screen container, this would result in a width of 160 points on an iPhone screen. However,
   * since 160 pts is higher than the maximum width of 120 pts, the maximum width would be used.
   */
  var maxSize: CGSize {
    @available(*, unavailable)
    get {
      fatalError()
    }
    set {
      _instance_lock.withCriticalScope {
        var newSize = _size.value
        newSize.maxWidth = .fixed(value: newValue.width)
        newSize.maxHeight = .fixed(value: newValue.height)
        _size.value = newSize
      }
      delegate?.layoutElementStyle(self, propertyDidChange: .maxWidth)
      delegate?.layoutElementStyle(self, propertyDidChange: .maxHeight)
    }
  }
  
  /**
   * @abstract Provides a suggested RELATIVE size for a layout element. An ASLayoutSize uses percentages rather
   * than points to specify layout. E.g. width should be 50% of the parent’s width. If the optional minLayoutSize or
   * maxLayoutSize are provided, and the preferredLayoutSize exceeds these, the minLayoutSize or maxLayoutSize
   * will be enforced. If this optional value is not provided, the layout element’s size will default to its intrinsic content size
   * provided calculateSizeThatFits:
   */
  var preferredLayoutSize: LayoutSize {
    get {
      let size = _size.value
      return LayoutSize(width: size.width, height: size.height)
    }
    set {
      _instance_lock.withCriticalScope {
        var newSize = _size.value
        newSize.width = newValue.width
        newSize.height = newValue.height
        _size.value = newSize
      }
      delegate?.layoutElementStyle(self, propertyDidChange: .width)
      delegate?.layoutElementStyle(self, propertyDidChange: .height)
    }
  }
  
  /**
   * @abstract An optional property that provides a minimum RELATIVE size bound for a layout element. If provided, this
   * restriction will always be enforced. If a parent layout element’s minimum relative size is smaller than its child’s minimum
   * relative size, the child’s minimum relative size will be enforced and its size will extend out of the layout spec’s.
   */
  var minLayoutSize: LayoutSize {
    get {
      let size = _size.value
      return LayoutSize(width: size.minWidth, height: size.minHeight)
    }
    set {
      _instance_lock.withCriticalScope {
        var newSize = _size.value
        newSize.minWidth = newValue.width
        newSize.minHeight = newValue.height
        _size.value = newSize
      }
      delegate?.layoutElementStyle(self, propertyDidChange: .minWidth)
      delegate?.layoutElementStyle(self, propertyDidChange: .minHeight)
    }
  }
  
  /**
   * @abstract An optional property that provides a maximum RELATIVE size bound for a layout element. If provided, this
   * restriction will always be enforced. If a parent layout element’s maximum relative size is smaller than its child’s maximum
   * relative size, the child’s maximum relative size will be enforced and its size will extend out of the layout spec’s.
   */
  var maxLayoutSize: LayoutSize {
    get {
      let size = _size.value
      return LayoutSize(width: size.maxWidth, height: size.maxHeight)
    }
    set {
      _instance_lock.withCriticalScope {
        var newSize = _size.value
        newSize.maxWidth = newValue.width
        newSize.maxHeight = newValue.height
        _size.value = newSize
      }
      delegate?.layoutElementStyle(self, propertyDidChange: .maxWidth)
      delegate?.layoutElementStyle(self, propertyDidChange: .maxHeight)
    }
  }
  
  private let _instance_lock = NSRecursiveLock()
  
  private var _extensions: LayoutElementStyleExtensions = .init()
  
  private let _size: Atomic<LayoutElementSize> = .init(value: .auto)
  private let _spacingBefore: Atomic<CGFloat> = .init(value: 0)
  private let _spacingAfter: Atomic<CGFloat> = .init(value: 0)
  private let _flexGrow: Atomic<CGFloat> = .init(value: 0)
  private let _flexShrink: Atomic<CGFloat> = .init(value: 0)
  private let _flexBasis: Atomic<Dimension> = .init(value: .auto)
  private let _alignSelf: Atomic<StackLayoutAlignSelf> = .init(value: .auto)
  private let _ascender: Atomic<CGFloat> = .init(value: 0)
  private let _descender: Atomic<CGFloat> = .init(value: 0)
  private let _layoutPosition: Atomic<CGPoint> = .init(value: .zero)
  
  /**
   * @abstract Initializes the layoutElement style with a specified delegate
   */
  init(delegate: LayoutElementStyleDelegate? = nil) {
    self.delegate = delegate
  }
}

extension LayoutElementStyle: StackLayoutElement {
  var spacingBefore: CGFloat {
    get {
      return _spacingBefore.value
    }
    set {
      _spacingBefore.value = newValue
      delegate?.layoutElementStyle(self, propertyDidChange: .spacingBefore)
    }
  }
  
  var spacingAfter: CGFloat {
    get {
      return _spacingAfter.value
    }
    set {
      _spacingAfter.value = newValue
      delegate?.layoutElementStyle(self, propertyDidChange: .spacingAfter)
    }
  }
  
  var flexGrow: CGFloat {
    get {
      return _flexGrow.value
    }
    set {
      _flexGrow.value = newValue
      delegate?.layoutElementStyle(self, propertyDidChange: .flexGrow)
    }
  }
  
  var flexShrink: CGFloat {
    get {
      return _flexShrink.value
    }
    set {
      _flexShrink.value = newValue
      delegate?.layoutElementStyle(self, propertyDidChange: .flexShrink)
    }
  }
  
  var flexBasis: Dimension {
    get {
      return _flexBasis.value
    }
    set {
      _flexBasis.value = newValue
      delegate?.layoutElementStyle(self, propertyDidChange: .flexBasis)
    }
  }
  
  var alignSelf: StackLayoutAlignSelf {
    get {
      return _alignSelf.value
    }
    set {
      _alignSelf.value = newValue
      delegate?.layoutElementStyle(self, propertyDidChange: .alignSelf)
    }
  }
  
  var ascender: CGFloat {
    get {
      return _ascender.value
    }
    set {
      _ascender.value = newValue
      delegate?.layoutElementStyle(self, propertyDidChange: .ascender)
    }
  }
  
  var descender: CGFloat {
    get {
      return _descender.value
    }
    set {
      _descender.value = newValue
      delegate?.layoutElementStyle(self, propertyDidChange: .descender)
    }
  }
  
}

extension LayoutElementStyle: AbsoluteLayoutElement {
  var layoutPosition: CGPoint {
    get {
      return _layoutPosition.value
    }
    set {
      _layoutPosition.value = newValue
      delegate?.layoutElementStyle(self, propertyDidChange: .layoutPosition)
    }
  }
}

extension LayoutElementStyle: LayoutElementExtensibility {
  func setLayoutOptionExtensionBool(_ value: Bool, atIndex index: Int) {
    _instance_lock.withCriticalScope {
      _extensions.boolExtensions[index] = value
    }
  }
  
  func layoutOptionExtensionBool(atIndex index: Int) -> Bool {
    return _instance_lock.withCriticalScope {
      return _extensions.boolExtensions[index]
    }
  }
  
  func setLayoutOptionExtensionInteger(_ value: Int, atIndex index: Int) {
    _instance_lock.withCriticalScope {
      _extensions.integerExtensions[index] = value
    }
  }
  
  func layoutOptionExtensionInteger(atIndex index: Int) -> Int {
    return _instance_lock.withCriticalScope {
      return _extensions.integerExtensions[index]
    }
  }
  
  func setLayoutOptionExtensionEdgeInsets(_ value: UIEdgeInsets, atIndex index: Int) {
    _instance_lock.withCriticalScope {
      _extensions.edgeInsetsExtensions[index] = value
    }
  }
  
  func layoutOptionExtensionEdgeInsets(atIndex index: Int) -> UIEdgeInsets {
    return _instance_lock.withCriticalScope {
      return _extensions.edgeInsetsExtensions[index]
    }
  }
  
  
}

protocol LayoutElementStylability {
  
  init(styleBlock: (LayoutElementStyle) -> Void)
  
}
