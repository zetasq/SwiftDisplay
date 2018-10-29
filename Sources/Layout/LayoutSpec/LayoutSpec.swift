//
//  LayoutSpec.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/10.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

final class NullLayoutSpec: LayoutSpec {
  
  static let null = NullLayoutSpec()
  
  private override init() {
    super.init()
  }
  
  override var isMutable: Bool {
    get {
      return false
    }
    set {
      // do nothing
    }
  }
  
  override func calculateLayoutThatFits(_ constrainedSize: SizeRange) -> Layout {
    return Layout(layoutElement: self, size: .zero)
  }
  
}

/**
 * A layout spec is an immutable object that describes a layout, loosely inspired by React.
 */
open class LayoutSpec: LayoutElement & LayoutElementExtensibility {
  
  

  /**
   * Creation of a layout spec should only happen by a user in layoutSpecThatFits:. During that method, a
   * layout spec can be created and mutated. Once it is passed back to ASDK, the isMutable flag will be
   * set to NO and any further mutations will cause an assert.
   */
  var isMutable: Bool = true
  
  /**
   * First child within the children's array.
   *
   * @discussion Every ASLayoutSpec must act on at least one child. The ASLayoutSpec base class takes the
   * responsibility of holding on to the spec children. Some layout specs, like ASInsetLayoutSpec,
   * only require a single child.
   *
   * For layout specs that require a known number of children (ASBackgroundLayoutSpec, for example)
   * a subclass should use this method to set the "primary" child. It can then use setChild:atIndex:
   * to set any other required children. Ideally a subclass would hide this from the user, and use the
   * setChild:atIndex: internally. For example, ASBackgroundLayoutSpec exposes a "background"
   * property that behind the scenes is calling setChild:atIndex:.
   */
//  var child: LayoutElement? {
//    get {
//      assert(_childrenArray.count < 2, "This layout spec does not support more than one child. Use the setChildren: or the setChild:AtIndex: API")
//      return _childrenArray.first
//    }
//    set {
//      assert(isMutable, "Cannot set properties when layout spec is not mutable")
//      assert(_childrenArray.count < 2, "This layout spec does not support more than one child. Use the setChildren: or the setChild:AtIndex: API")
//      
//      if let element = newValue {
//        _childrenArray.insert(element, at: 0)
//      } else {
//        if !_childrenArray.isEmpty {
//          _childrenArray.removeFirst()
//        }
//      }
//    }
//  }
//  
  /**
   * An array of ASLayoutElement children
   *
   * @discussion Every ASLayoutSpec must act on at least one child. The ASLayoutSpec base class takes the
   * reponsibility of holding on to the spec children. Some layout specs, like ASStackLayoutSpec,
   * can take an unknown number of children. In this case, the this method should be used.
   * For good measure, in these layout specs it probably makes sense to define
   * setChild: and setChild:forIdentifier: methods to do something appropriate or to assert.
   */
  var children: [LayoutElement] {
    get {
      return _childrenArray
    }
    set {
      assert(isMutable, "Cannot set properties when layout spec is not mutable")
      
      _childrenArray = newValue
    }
  }
  
  private let _instance_lock = NSRecursiveLock()
  
  private let _primitiveTraitCollection: Atomic<PrimitiveTraitCollection> = .init(value: .default)
  
  private let _style: LayoutElementStyle
  
  private var _childrenArray: [LayoutElement] = []
  
  init() {
    _style = LayoutElementStyle(delegate: nil)
  }
  
  /**
   * Recursively search the subtree for elements that occur more than once.
   */
  func hasDuplicatedElementsInSubtree() -> Bool {
    var visitedIDs: Set<ObjectIdentifier> = []
    var stack = _childrenArray
    
    while !stack.isEmpty {
      let countBefore = visitedIDs.count
      visitedIDs.insert(ObjectIdentifier(stack.popLast()!))
      let countAfter = visitedIDs.count
      
      if countBefore == countAfter {
        return true
      }
    }
    
    return false
  }
  
  var canLayoutAsynchronous: Bool {
    return true
  }
  
  var child: LayoutElement {
    get {
      return child(atIndex: 0)
    }
    set {
      setChild(newValue, atIndex: 0)
    }
  }
  
  func setChild(_ child: LayoutElement?, atIndex index: Int) {
    assert(self.isMutable, "Cannot set properties when layout spec is not mutable")
    
    let layoutElement = child ?? NullLayoutSpec.null
    
    if _childrenArray.count < index {
      // Fill up the array with null objects until the index
      for _ in _childrenArray.count..<index {
        _childrenArray.append(NullLayoutSpec.null)
      }
    }
    
    _childrenArray[index] = layoutElement
  }
  
  func child(atIndex index: Int) -> LayoutElement {
    guard index < _childrenArray.count else {
      return NullLayoutSpec.null
    }
    
    let layoutElement = _childrenArray[index]
    assert(layoutElement !== NullLayoutSpec.null, "Access child at index without set a child at that index")
    return layoutElement
  }

// MARK: - LayoutElement & LayoutElementExtensibility
  var layoutElementType: LayoutElementType {
    return .layoutSpec
  }
  
  var style: LayoutElementStyle {
    return _instance_lock.withCriticalScope {
      return _style
    }
  }
  
  var sublayoutElements: [LayoutElement] {
    return _childrenArray
  }
  
  var implementsLayoutMethod: Bool {
    return true
  }
  
  var asciiArtString: String {
    return "" // TODO:
  }
  
  var asciiArtName: String {
    return "" // TODO:
  }
  
  var primitiveTraitCollection: PrimitiveTraitCollection {
    get {
      return _primitiveTraitCollection.value
    }
    set {
      _primitiveTraitCollection.value = newValue
    }
  }
  
  var asyncTraitCollection: TraitCollection {
    return _instance_lock.withCriticalScope {
      return TraitCollection(primitiveTraitCollection: primitiveTraitCollection)
    }
  }
  
  func calculateLayoutThatFits(_ constrainedSize: SizeRange) -> Layout {
    return Layout(layoutElement: self, size: constrainedSize.minSize)
  }
  
  
}

