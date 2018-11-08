//
//  DisplayNode.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/11/7.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation
import UIKit

/**
 * An `ASDisplayNode` is an abstraction over `UIView` and `CALayer` that allows you to perform calculations about a view
 * hierarchy off the main thread, and could do rendering off the main thread as well.
 *
 * The node API is designed to be as similar as possible to `UIView`. See the README for examples.
 *
 * ## Subclassing
 *
 * `ASDisplayNode` can be subclassed to create a new UI element. The subclass header `ASDisplayNode+Subclasses` provides
 * necessary declarations and conveniences.
 *
 * Commons reasons to subclass includes making a `UIView` property available and receiving a callback after async
 * display.
 *
 */
open class DisplayNode {
  
  // MARK: - Initializing a node object

  /**
   * @abstract Designated initializer.
   *
   * @return An ASDisplayNode instance whose view will be a subclass that enables asynchronous rendering, and passes
   * through -layout and touch handling methods.
   */
  public init() {
    fatalError()
  }
  
  /**
   * @abstract Alternative initializer with a block to create the backing view.
   *
   * @param viewBlock The block that will be used to create the backing view.
   * @param didLoadBlock The block that will be called after the view created by the viewBlock is loaded
   *
   * @return An ASDisplayNode instance that loads its view with the given block that is guaranteed to run on the main
   * queue. The view will render synchronously and -layout and touch handling methods on the node will not be called.
   */
  public init(viewBlock: ViewBlock, didLoadBlock: DidLoadBlock? = nil) {
    fatalError()
  }
  
  /**
   * @abstract Alternative initializer with a block to create the backing layer.
   *
   * @param layerBlock The block that will be used to create the backing layer.
   * @param didLoadBlock The block that will be called after the layer created by the layerBlock is loaded
   *
   * @return An ASDisplayNode instance that loads its layer with the given block that is guaranteed to run on the main
   * queue. The layer will render synchronously and -layout and touch handling methods on the node will not be called.
   */
  public init(layerBlock: LayerBlock, didLoadBlock: DidLoadBlock? = nil) {
    fatalError()
  }
  
  /**
   * @abstract Add a block of work to be performed on the main thread when the node's view or layer is loaded. Thread safe.
   * @warning Be careful not to retain self in `body`. Change the block parameter list to `^(MYCustomNode *self) {}` if you
   *   want to shadow self (e.g. if calling this during `init`).
   *
   * @param body The work to be performed when the node is loaded.
   *
   * @precondition The node is not already loaded.
   */
  public final func onDidLoad(_ body: DidLoadBlock) {
    
  }
  
  /**
   * Set the block that should be used to load this node's view.
   *
   * @param viewBlock The block that creates a view for this node.
   *
   * @precondition The node is not yet loaded.
   *
   * @note You will usually NOT call this. See the limitations documented in @c initWithViewBlock:
   */
  public final func setViewBlock(_ viewBlock: ViewBlock) {
    
  }
  
  /**
   * Set the block that should be used to load this node's layer.
   *
   * @param layerBlock The block that creates a layer for this node.
   *
   * @precondition The node is not yet loaded.
   *
   * @note You will usually NOT call this. See the limitations documented in @c initWithLayerBlock:
   */
  public final func setLayerBlock(_ layerBlock: LayerBlock) {
    
  }
  
  /**
   * @abstract Returns whether the node is synchronous.
   *
   * @return NO if the node wraps a _ASDisplayView, YES otherwise.
   */
  public final var isSynchronous: Bool {
    fatalError()
  }
  
  // MARK: - Getting view and layer
  /**
   * @abstract Returns a view.
   *
   * @discussion The view property is lazily initialized, similar to UIViewController.
   * To go the other direction, use ASViewToDisplayNode() in ASDisplayNodeExtras.h.
   *
   * @warning The first access to it must be on the main thread, and should only be used on the main thread thereafter as
   * well.
   */
  public final var view: UIView {
    fatalError()
  }
  
  /**
   * @abstract Returns whether a node's backing view or layer is loaded.
   *
   * @return YES if a view is loaded, or if layerBacked is YES and layer is not nil; NO otherwise.
   */
  public final var isNodeLoaded: Bool {
    fatalError()
  }
  
  /**
   * @abstract Returns whether the node rely on a layer instead of a view.
   *
   * @return YES if the node rely on a layer, NO otherwise.
   */
  public final var isLayerBacked: Bool {
    fatalError()
  }
  
  /**
   * @abstract Returns a layer.
   *
   * @discussion The layer property is lazily initialized, similar to the view property.
   * To go the other direction, use ASLayerToDisplayNode() in ASDisplayNodeExtras.h.
   *
   * @warning The first access to it must be on the main thread, and should only be used on the main thread thereafter as
   * well.
   */
  public final var layer: CALayer {
    fatalError()
  }
  
  /**
   * Returns YES if the node is – at least partially – visible in a window.
   *
   * @see didEnterVisibleState and didExitVisibleState
   */
  public final var isVisible: Bool {
    fatalError()
  }
  
  /**
   * Returns YES if the node is in the preloading interface state.
   *
   * @see didEnterPreloadState and didExitPreloadState
   */
  public final var isInPreloadState: Bool {
    fatalError()
  }
  
  /**
   * Returns YES if the node is in the displaying interface state.
   *
   * @see didEnterDisplayState and didExitDisplayState
   */
  public final var isInDisplayState: Bool {
    fatalError()
  }
  
  /**
   * @abstract Returns the Interface State of the node.
   *
   * @return The current ASInterfaceState of the node, indicating whether it is visible and other situational properties.
   *
   * @see ASInterfaceState
   */
  public final var interfaceState: InterfaceState {
    fatalError()
  }
  
  /**
   * @abstract Adds a delegate to receive notifications on interfaceState changes.
   *
   * @warning This must be called from the main thread.
   * There is a hard limit on the number of delegates a node can have; see
   * AS_MAX_INTERFACE_STATE_DELEGATES above.
   *
   * @see ASInterfaceState
   */
  public final func AddInterfaceStateDelegate(_ interfaceStateDelegate: InterfaceStateDelegate) {
    fatalError()
  }
  
  /**
   * @abstract Removes a delegate from receiving notifications on interfaceState changes.
   *
   * @warning This must be called from the main thread.
   *
   * @see ASInterfaceState
   */
  public final func removeInterfaceStateDelegate(_ interfaceStateDelegate: InterfaceStateDelegate) {
    fatalError()
  }
  
  /**
   * @abstract Class property that allows to set a block that can be called on non-fatal errors. This
   * property can be useful for cases when Async Display Kit can recover from an abnormal behavior, but
   * still gives the opportunity to use a reporting mechanism to catch occurrences in production. In
   * development, Async Display Kit will assert instead of calling this block.
   *
   * @warning This method is not thread-safe.
   */
  public static var nonFatalErrorBlock: NonFatalErrorBlock?
  
  // MARK: - Managing the nodes hierarchy
  
  
  /**
   * @abstract Add a node as a subnode to this node.
   *
   * @param subnode The node to be added.
   *
   * @discussion The subnode's view will automatically be added to this node's view, lazily if the views are not created
   * yet.
   */
  public final func addSubnode(_ subnode: DisplayNode) {
    
  }
  
  /**
   * @abstract Insert a subnode before a given subnode in the list.
   *
   * @param subnode The node to insert below another node.
   * @param below The sibling node that will be above the inserted node.
   *
   * @discussion If the views are loaded, the subnode's view will be inserted below the given node's view in the hierarchy
   * even if there are other non-displaynode views.
   */
  public final func insertSubnode(_ subnode: DisplayNode, belowSubnode siblingSubnode: DisplayNode) {
    
  }
  
  /**
   * @abstract Insert a subnode after a given subnode in the list.
   *
   * @param subnode The node to insert below another node.
   * @param above The sibling node that will be behind the inserted node.
   *
   * @discussion If the views are loaded, the subnode's view will be inserted above the given node's view in the hierarchy
   * even if there are other non-displaynode views.
   */
  public final func insertSubnode(_ subnode: DisplayNode, aboveSubnode siblingSubnode: DisplayNode) {
    
  }
  
  /**
   * @abstract Insert a subnode at a given index in subnodes.
   *
   * @param subnode The node to insert.
   * @param idx The index in the array of the subnodes property at which to insert the node. Subnodes indices start at 0
   * and cannot be greater than the number of subnodes.
   *
   * @discussion If this node's view is loaded, ASDisplayNode insert the subnode's view after the subnode at index - 1's
   * view even if there are other non-displaynode views.
   */
  public final func insertSubnode(_ subnode: DisplayNode, at index: Int) {
    
  }
  
  /**
   * @abstract Replace subnode with replacementSubnode.
   *
   * @param subnode A subnode of self.
   * @param replacementSubnode A node with which to replace subnode.
   *
   * @discussion Should both subnode and replacementSubnode already be subnodes of self, subnode is removed and
   * replacementSubnode inserted in its place.
   * If subnode is not a subnode of self, this method will throw an exception.
   * If replacementSubnode is nil, this method will throw an exception
   */
  public final func replaceSubnode(_ subnode: DisplayNode, with replacementSubnode: DisplayNode) {
    
  }
  
  /**
   * @abstract Remove this node from its supernode.
   *
   * @discussion The node's view will be automatically removed from the supernode's view.
   */
  public final func removeFromSupernode() {
    
  }
  
  /**
   * @abstract The receiver's immediate subnodes.
   */
  public final var subnodes: [DisplayNode] {
    fatalError()
  }
  
  /**
   * @abstract The receiver's supernode.
   */
  public final var supernode: DisplayNode? {
    fatalError()
  }
  
  // MARK: - Drawing and Updating the View

  /**
   * @abstract Whether this node's view performs asynchronous rendering.
   *
   * @return Defaults to YES, except for synchronous views (ie, those created with -initWithViewBlock: /
   * -initWithLayerBlock:), which are always NO.
   *
   * @discussion If this flag is set, then the node will participate in the current asyncdisplaykit_async_transaction and
   * do its rendering on the displayQueue instead of the main thread.
   *
   * Asynchronous rendering proceeds as follows:
   *
   * When the view is initially added to the hierarchy, it has -needsDisplay true.
   * After layout, Core Animation will call -display on the _ASDisplayLayer
   * -display enqueues a rendering operation on the displayQueue
   * When the render block executes, it calls the delegate display method (-drawRect:... or -display)
   * The delegate provides contents via this method and an operation is added to the asyncdisplaykit_async_transaction
   * Once all rendering is complete for the current asyncdisplaykit_async_transaction,
   * the completion for the block sets the contents on all of the layers in the same frame
   *
   * If asynchronous rendering is disabled:
   *
   * When the view is initially added to the hierarchy, it has -needsDisplay true.
   * After layout, Core Animation will call -display on the _ASDisplayLayer
   * -display calls  delegate display method (-drawRect:... or -display) immediately
   * -display sets the layer contents immediately with the result
   *
   * Note: this has nothing to do with -[CALayer drawsAsynchronously].
   */
  public final var displaysAsynchronously: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  /**
   * @abstract Prevent the node's layer from displaying.
   *
   * @discussion A subclass may check this flag during -display or -drawInContext: to cancel a display that is already in
   * progress.
   *
   * Defaults to NO. Does not control display for any child or descendant nodes; for that, use
   * -recursivelySetDisplaySuspended:.
   *
   * If a setNeedsDisplay occurs while displaySuspended is YES, and displaySuspended is set to NO, then the
   * layer will be automatically displayed.
   */
  public final var displaySuspended: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  /**
   * @abstract Whether size changes should be animated. Default to YES.
   */
  public final var shouldAnimateSizeChanges: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  /**
   * @abstract Prevent the node and its descendants' layer from displaying.
   *
   * @param flag YES if display should be prevented or cancelled; NO otherwise.
   *
   * @see displaySuspended
   */
  public final func recursivelySetDisplaySuspended(_ flag: Bool) {
    
  }
  
  /**
   * @abstract Calls -clearContents on the receiver and its subnode hierarchy.
   *
   * @discussion Clears backing stores and other memory-intensive intermediates.
   * If the node is removed from a visible hierarchy and then re-added, it will automatically trigger a new asynchronous display,
   * as long as displaySuspended is not set.
   * If the node remains in the hierarchy throughout, -setNeedsDisplay is required to trigger a new asynchronous display.
   *
   * @see displaySuspended and setNeedsDisplay
   */
  public final func recursivelyClearContents() {
    
  }
  
  /**
   * @abstract Toggle displaying a placeholder over the node that covers content until the node and all subnodes are
   * displayed.
   *
   * @discussion Defaults to NO.
   */
  public final let placeholderEnabled: Atomic<Bool> = .init(value: false)
  
  /**
   * @abstract Set the time it takes to fade out the placeholder when a node's contents are finished displaying.
   *
   * @discussion Defaults to 0 seconds.
   */
  public final let placeholderFadeDuration: Atomic<TimeInterval> = .init(value: 0)
  
  // MARK: - Hit Testing
  
  /**
   * @abstract Bounds insets for hit testing.
   *
   * @discussion When set to a non-zero inset, increases the bounds for hit testing to make it easier to tap or perform
   * gestures on this node.  Default is UIEdgeInsetsZero.
   *
   * This affects the default implementation of -hitTest and -pointInside, so subclasses should call super if you override
   * it and want hitTestSlop applied.
   */
  public final var histTestSlop: UIEdgeInsets {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  /**
   * @abstract Returns a Boolean value indicating whether the receiver contains the specified point.
   *
   * @discussion Includes the "slop" factor specified with hitTestSlop.
   *
   * @param point A point that is in the receiver's local coordinate system (bounds).
   * @param event The event that warranted a call to this method.
   *
   * @return YES if point is inside the receiver's bounds; otherwise, NO.
   */
  public final func pointInside(_ point: CGPoint, withEvent event: UIEvent?) -> Bool {
    fatalError()
  }
  
  // MARK: - Converting Between View Coordinate Systems
  
  /**
   * @abstract Converts a point from the receiver's coordinate system to that of the specified node.
   *
   * @param point A point specified in the local coordinate system (bounds) of the receiver.
   * @param node The node into whose coordinate system point is to be converted.
   *
   * @return The point converted to the coordinate system of node.
   */
  public final func convertPoint(_ point: CGPoint, toNode node: DisplayNode?) -> CGPoint {
    fatalError()
  }
  
  /**
   * @abstract Converts a point from the coordinate system of a given node to that of the receiver.
   *
   * @param point A point specified in the local coordinate system (bounds) of node.
   * @param node The node with point in its coordinate system.
   *
   * @return The point converted to the local coordinate system (bounds) of the receiver.
   */
  public final func convertPoint(_ point: CGPoint, fromNode node: DisplayNode?) -> CGPoint {
    fatalError()
  }
  
  /**
   * @abstract Converts a rectangle from the receiver's coordinate system to that of another view.
   *
   * @param rect A rectangle specified in the local coordinate system (bounds) of the receiver.
   * @param node The node that is the target of the conversion operation.
   *
   * @return The converted rectangle.
   */
  public final func convertRect(_ rect: CGRect, toNode node: DisplayNode?) -> CGRect {
    fatalError()
  }
  
  /**
   * @abstract Converts a rectangle from the coordinate system of another node to that of the receiver.
   *
   * @param rect A rectangle specified in the local coordinate system (bounds) of node.
   * @param node The node with rect in its coordinate system.
   *
   * @return The converted rectangle.
   */
  public final func convertRect(_ rect: CGRect, fromNode node: DisplayNode?) -> CGRect {
    fatalError()
  }
  
  /**
   * Whether or not the node would support having .layerBacked = YES.
   */
  public final var supportsLayerBacking: Bool {
    fatalError()
  }
  
  /**
   * Whether or not the node layout should be automatically updated when it receives safeAreaInsetsDidChange.
   *
   * Defaults to NO.
   */
  public final var automaticallyRelayoutOnSafeAreaChanges: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  /**
   * Whether or not the node layout should be automatically updated when it receives layoutMarginsDidChange.
   *
   * Defaults to NO.
   */
  public final var automaticallyRelayoutOnLayoutMarginsChanges: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
}

// MARK: - UIView bridge
/**
 * ## UIView bridge
 *
 * ASDisplayNode provides thread-safe access to most of UIView and CALayer properties and methods, traditionally unsafe.
 *
 * Using them will not cause the actual view/layer to be created, and will be applied when it is created (when the view
 * or layer property is accessed).
 *
 * - NOTE: After the view or layer is created, the properties pass through to the view or layer directly and must be called on the main thread.
 *
 * See UIView and CALayer for documentation on these common properties.
 */
extension DisplayNode {
  
  /**
   * Marks the view as needing display. Convenience for use whether the view / layer is loaded or not. Safe to call from a background thread.
   */
  public final func setNeedsDisplay() {
    fatalError()
  }
  
  /**
   * Marks the node as needing layout. Convenience for use whether the view / layer is loaded or not. Safe to call from a background thread.
   *
   * If the node determines its own desired layout size will change in the next layout pass, it will propagate this
   * information up the tree so its parents can have a chance to consider and apply if necessary the new size onto the node.
   *
   * Note: ASCellNode has special behavior in that calling this method will automatically notify
   * the containing ASTableView / ASCollectionView that the cell should be resized, if necessary.
   */
  public final func setNeedsLayout() {
    fatalError()
  }
  
  /**
   * Performs a layout pass on the node. Convenience for use whether the view / layer is loaded or not. Safe to call from a background thread.
   */
  public final func layoutIfNeeded() {
    
  }
  
  // default=CGRectZero
  public final var frame: CGRect {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default=CGRectZero
  public final var bounds: CGRect {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default=CGPointZero
  public final var position: CGPoint {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default=1.0f
  public final var alpha: CGFloat {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  /* @abstract Sets the corner rounding method to use on the ASDisplayNode.
   * There are three types of corner rounding provided by Texture: CALayer, Precomposited, and Clipping.
   *
   * - ASCornerRoundingTypeDefaultSlowCALayer: uses CALayer's inefficient .cornerRadius property. Use
   * this type of corner in situations in which there is both movement through and movement underneath
   * the corner (very rare). This uses only .cornerRadius.
   *
   * - ASCornerRoundingTypePrecomposited: corners are drawn using bezier paths to clip the content in a
   * CGContext / UIGraphicsContext. This requires .backgroundColor and .cornerRadius to be set. Use opaque
   * background colors when possible for optimal efficiency, but transparent colors are supported and much
   * more efficient than CALayer. The only limitation of this approach is that it cannot clip children, and
   * thus works best for ASImageNodes or containers showing a background around their children.
   *
   * - ASCornerRoundingTypeClipping: overlays 4 seperate opaque corners on top of the content that needs
   * corner rounding. Requires .backgroundColor and .cornerRadius to be set. Use clip corners in situations
   * in which is movement through the corner, with an opaque background (no movement underneath the corner).
   * Clipped corners are ideal for animating / resizing views, and still outperform CALayer.
   *
   * For more information and examples, see http://texturegroup.org/docs/corner-rounding.html
   *
   * @default ASCornerRoundingTypeDefaultSlowCALayer
   */
  public final var cornerRoundingType: CornerRoundingType {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  /** @abstract The radius to use when rounding corners of the ASDisplayNode.
   *
   * @discussion This property is thread-safe and should always be preferred over CALayer's cornerRadius property,
   * even if corner rounding type is ASCornerRoundingTypeDefaultSlowCALayer.
   */
  // default=0.0
  public final var cornerRadius: CGFloat {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default==NO
  public final var clipsToBounds: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default==NO
  public final var isHidden: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default==YES
  public final var isOpaque: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default=nil
  public final var contents: Any? {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default={0,0,1,1}. @see CALayer.h for details.
  public final var contentsRect: CGRect {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default={0,0,1,1}. @see CALayer.h for details.
  public final var contentsCenter: CGRect {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default=1.0f. See @contentsScaleForDisplay for details.
  public final var contentsScale: CGFloat {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default=1.0f.
  public final var rasterizationScale: CGFloat {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default={0.5, 0.5}
  public final var anchorPoint: CGPoint {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default=0.0
  public final var zPosition: CGFloat {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default=CATransform3DIdentity
  public final var transform: CATransform3D {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default=CATransform3DIdentity
  public final var subnodeTransform: CATransform3D {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default=YES (NO for layer-backed nodes)
  public final var isUserInteractionEnabled: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default=NO
  public final var isExclusiveTouch: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  /**
   * @abstract The node view's background color.
   *
   * @discussion In contrast to UIView, setting a transparent color will not set opaque = NO.
   * This only affects nodes that implement +drawRect like ASTextNode.
   */
  // default=nil
  public final var backgroundColor: UIColor {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default=Blue
  public final var tintColor: UIColor! {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // Notifies the node when the tintColor has changed.
  open func tintColorDidChange() {}
  
  /**
   * @abstract A flag used to determine how a node lays out its content when its bounds change.
   *
   * @discussion This is like UIView's contentMode property, but better. We do our own mapping to layer.contentsGravity in
   * _ASDisplayView. You can set needsDisplayOnBoundsChange independently.
   * Thus, UIViewContentModeRedraw is not allowed; use needsDisplayOnBoundsChange = YES instead, and pick an appropriate
   * contentMode for your content while it's being re-rendered.
   */
  // default=UIViewContentModeScaleToFill
  public final var contentMode: UIView.ContentMode {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // Use .contentMode in preference when possible.
  public final var contentsGravity: String {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  public final var semanticContentAttribute: UISemanticContentAttribute {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default=opaque rgb black
  public final var shadowColor: CGColor? {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default=0.0
  public final var shadowOpacity: CGFloat {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default=(0, -3)
  public final var shadowOffset: CGSize {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default=3
  public final var shadowRadius: CGFloat {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default=0
  public final var borderWidth: CGFloat {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default=opaque rgb black
  public final var borderColor: CGColor? {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  public final var allowsGroupOpacity: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  public final var allowsEdgeAntialiasing: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default==all values from CAEdgeAntialiasingMask
  public final var edgeAntialiasingMask: CAEdgeAntialiasingMask {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default==NO
  public final var needsDisplayOnBoundsChange: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default==YES (undefined for layer-backed nodes)
  public final var autoresizesSubviews: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default==UIViewAutoresizingNone (undefined for layer-backed nodes)
  public final var autoresizingMask: UIView.AutoresizingMask {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  /**
   * @abstract Content margins
   *
   * @discussion This property is bridged to its UIView counterpart.
   *
   * If your layout depends on this property, you should probably enable automaticallyRelayoutOnLayoutMarginsChanges to ensure
   * that the layout gets automatically updated when the value of this property changes. Or you can override layoutMarginsDidChange
   * and make all the necessary updates manually.
   */
  public final var layoutMargins: UIEdgeInsets {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  // default is NO - set to enable pass-through or cascading behavior of margins from this view’s parent to its children
  public final var preservesSuperviewLayoutMargins: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  open func layoutMarginsDidChange() {
    fatalError()
  }
  
  /**
   * @abstract Safe area insets
   *
   * @discussion This property is bridged to its UIVIew counterpart.
   *
   * If your layout depends on this property, you should probably enable automaticallyRelayoutOnSafeAreaChanges to ensure
   * that the layout gets automatically updated when the value of this property changes. Or you can override safeAreaInsetsDidChange
   * and make all the necessary updates manually.
   */
  public final var safeAreaInsets: UIEdgeInsets {
    fatalError()
  }
  
  // Default: YES
  public final var insetsLayoutMarginsFromSafeArea: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  open func safeAreaInsetsDidChange() {
    fatalError()
  }
  
  // MARK: - UIResponder methods
  // By default these fall through to the underlying view, but can be overridden.
  
  // default==NO
  open var canBecomeFirstResponder: Bool {
    fatalError()
  }
  
  // default==NO (no-op)
  open func becomeFirstResponder() -> Bool {
    fatalError()
  }
  
  // default==YES
  open var canResignFirstResponder: Bool {
    fatalError()
  }
  
  // default==NO (no-op)
  open func resignFirstResponder() -> Bool {
    fatalError()
  }
  
  open var isFirstResponder: Bool {
    fatalError()
  }
  
  open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    fatalError()
  }
}

// MARK: - UIViewBridgeAccessibility
extension DisplayNode {
  
  public final var isAccessibilityElement: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  public final var accessibilityLabel: String? {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  public final var accessibilityAttributedLabel: NSAttributedString? {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  public final var accessibilityHint: String? {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  public final var accessibilityAttributedHint: NSAttributedString? {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  public final var accessibilityValue: String? {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  public final var accessibilityAttributedValue: NSAttributedString? {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  public final var accessibilityTraits: UIAccessibilityTraits {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  public final var accessibilityFrame: CGRect {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  public final var accessibilityPath: UIBezierPath? {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  public final var accessibilityActivationPoint: CGPoint {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  public final var accessibilityLanguage: String? {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  public final var accessibilityElementsHidden: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  public final var accessibilityViewIsModal: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  public final var shouldGroupAccessibilityChildren: Bool {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  public final var accessibilityNavigationStyle: UIAccessibilityNavigationStyle {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
  
  public final var accessibilityIdentifier: String? {
    get {
      fatalError()
    }
    set {
      fatalError()
    }
  }
}
