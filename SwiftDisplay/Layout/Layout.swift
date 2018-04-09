//
//  Layout.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/6.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

/**
 * A node in the layout tree that represents the size and position of the object that created it (ASLayoutElement).
 */
final class Layout {
    
//  /**
//   * Set to YES to tell all ASLayout instances to retain their sublayout elements. Defaults to NO.
//   * Can be overridden at instance level.
//   */
//  static func setShouldRetainSublayoutLayoutElements(_ shouldRetain: Bool) {
//
//  }
//
//  /**
//   * Whether or not ASLayout instances should retain their sublayout elements.
//   * Can be overridden at instance level.
//   */
//  static var shouldRetainSublayoutLayoutElements: Bool {
//
//  }
  
  /**
   * The underlying object described by this layout
   */
  private(set) weak var layoutElement: LayoutElement?
  
  /**
   * The type of ASLayoutElement that created this layout
   */
  let type: LayoutElementType
  
  /**
   * Size of the current layout
   */
  let size: CGSize
  
  /**
   * Position in parent. Default to nil.
   *
   * @discussion When being used as a sublayout, this property must not be nil.
   */
  var position: CGPoint?
  
  /**
   * Array of ASLayouts. Each must have a valid non-nil position.
   */
  let sublayouts: [Layout]

  /*
   * Caches all sublayouts if set to YES or destroys the sublayout cache if set to NO. Defaults to NO
   */
  private var retainSublayoutLayoutElements: Bool {
    didSet {
      guard retainSublayoutLayoutElements != oldValue else {
        return
      }
      
      self.sublayoutLayoutElements.removeAll()

      
      if retainSublayoutLayoutElements {
        // Add sublayouts layout elements to an internal array to retain it while the layout lives
        for sublayout in self.sublayouts {
          self.sublayoutLayoutElements.append(sublayout.layoutElement!)
        }
      }
    }
  }
  
  /**
   * Array for explicitly retain sublayout layout elements in case they are created and references in layoutSpecThatFits: and no one else will hold a strong reference on it
   */
  private var sublayoutLayoutElements: [LayoutElement]
  
  private var elementToRectMap: WeakLayoutElementToRectMap
  
  /**
   * Designated initializer
   
   * @param layoutElement The backing ASLayoutElement object.
   * @param size             The size of this layout.
   * @param position         The position of this layout within its parent (if available).
     
     if position is nil, 
     * Best used by ASDisplayNode subclasses that are manually creating a layout for -calculateLayoutThatFits:,
     * or for ASLayoutSpec subclasses that are referencing the "self" level in the layout tree,
     * or for creating a sublayout of which the position is yet to be determined.
     
   * @param sublayouts       Sublayouts belong to the new layout.
     
     if sublayouts is empty,
     
     * Best used for creating a layout that has no sublayouts, and is either a root one
     * or a sublayout of which the position is yet to be determined.
     *
     
   */
  init(layoutElement: LayoutElement,
       size: CGSize,
       position: CGPoint? = nil,
       sublayouts: [Layout] = []) {
    for sublayout in sublayouts {
      assert(sublayout.position != nil, "Nil position is not allowed in sublayout.")
    }
    
    self.layoutElement = layoutElement
    
    // Read this now to avoid @c weak overhead later.
    self.type = layoutElement.layoutElementType
    
    if !size.isValidForLayout {
      assert(false, "layoutSize is invalid and unsafe to provide to Core Animation! Release configurations will force to {0, 0}.  Size = \(size), node = \(layoutElement)")
      self.size = .zero
    } else {
      self.size = size.ceilPixelValue
    }
    
    self.position = position?.ceilPixelValue
    self.sublayouts = sublayouts
    
    self.elementToRectMap = WeakLayoutElementToRectMap()
    for layout in sublayouts {
      if let layoutElement = layout.layoutElement {
        self.elementToRectMap[layoutElement] = layout.frame
      }
    }
    
    self.retainSublayoutLayoutElements = false
    self.sublayoutLayoutElements = []
  }

  // A layout is flattened if its position is null, and all of its sublayouts are of type displaynode with no sublayouts.
  var isFlattened: Bool {
    guard position == nil else {
      return false
    }
    
    for sublayout in sublayouts {
      if sublayout.type != .displayNode || !sublayout.sublayouts.isEmpty {
        return false
      }
    }
    
    return true
  }
  
  /**
   * Traverses the existing layout tree and generates a new tree that represents only ASDisplayNode layouts
   */
  func filteredNodeLayoutTree() -> Layout {
    guard !isFlattened else {
      // All flattened layouts must have this flag enabled
      // to ensure sublayout elements are retained until the layouts are applied.
      retainSublayoutLayoutElements = true
      return self
    }
    
    struct Context {
      let layout: Layout
      let absolutePosition: CGPoint
    }
    
    // TODO: Implement Dequeue data structure (maybe by using array and indices?)
    var queue: [Context] = []
    for sublayout in sublayouts {
      queue.append(Context(layout: sublayout, absolutePosition: sublayout.position!))
    }
    
    var flattenedSublayouts: [Layout] = []
    
    while !queue.isEmpty {
      let context = queue.removeFirst()
      
      var layout = context.layout
      let sublayouts = layout.sublayouts
      let sublayoutsCount = sublayouts.count
      let absolutePosition = context.absolutePosition
      
      if layout.type == .displayNode {
        if sublayoutsCount > 0 || absolutePosition.ceilPixelValue != layout.position {
          // Only create a new layout if the existing one can't be reused, which means it has either some sublayouts or an invalid absolute position.
          layout = Layout(layoutElement: layout.layoutElement!, size: layout.size, position: absolutePosition, sublayouts: [])
        }
        flattenedSublayouts.append(layout)
      } else if sublayoutsCount > 0 {
        var sublayoutContexts: [Context] = []
        for sublayout in sublayouts {
          let sublayoutPosition = sublayout.position!
          
          let position = CGPoint(x: absolutePosition.x + sublayoutPosition.x, y: absolutePosition.y + sublayoutPosition.y)
          
          sublayoutContexts.append(Context(layout: sublayout, absolutePosition: position))
        }
        
        queue.insert(contentsOf: sublayoutContexts, at: 0)
      }
    }
    
    let layout = Layout(layoutElement: layoutElement!, size: size, position: nil, sublayouts: flattenedSublayouts)
    
    // All flattened layouts must have this flag enabled
    // to ensure sublayout elements are retained until the layouts are applied.
    layout.retainSublayoutLayoutElements = true
    return layout
  }
  
  
  /**
   * The frame for the given element, or nil if
   * the element is not a direct descendent of this layout.
   */
  func frame(for layoutElement: LayoutElement) -> CGRect? {
    return elementToRectMap[layoutElement]
  }
  
  
  /**
   * @abstract Returns a valid frame for the current layout computed with the size and position.
   * @discussion Clamps the layout's origin or position to 0 if any of the calculated values are infinite.
   */
  var frame: CGRect {
    assert(position != nil, "Layout has invalid position (nil)")
    assert(size.isValidForLayout, "Layout has an invalid size")

    return CGRect(origin: position ?? .zero, size: size.isValidForLayout ? size : .zero)
  }

}

extension Layout: Equatable {
  
  static func == (lhs: Layout, rhs: Layout) -> Bool {
    guard lhs.size == rhs.size else {
      return false
    }
    
    guard lhs.position == rhs.position else {
      return false
    }
    
    guard lhs.layoutElement === rhs.layoutElement else {
      return false
    }
    
    return lhs.sublayouts == rhs.sublayouts
  }
  
}


/**
 * Creates an defined number of "    |" indent blocks for the recursive description.
 */
internal func descriptionIndents(_ indents: Int) -> String {
  var description = String(repeating: "    |", count: indents)

  if indents > 0 {
    description += " "
  }
  
  return description
}

