//
//  _AsyncTransactionContainer.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/10/30.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

@objc
internal enum _AsyncTransactionContainerState: Int {
  /**
   The async container has no outstanding transactions.
   Whatever it is displaying is up-to-date.
   */
  case noTransactions
  
  /**
   The async container has one or more outstanding async transactions.
   Its contents may be out of date or showing a placeholder, depending on the configuration of the contained ASDisplayLayers.
   */
  case pendingTransactions
  
}

@objc
internal protocol _AsyncTransactionContainer: AnyObject {
  
  /**
   @summary If YES, the receiver is marked as a container for async transactions, grouping all of the transactions
   in the container hierarchy below the receiver together in a single ASAsyncTransaction.
   
   @default NO
   */
  var isAsyncTransactionContainer: Bool { get set }
  
  /**
   @summary The current state of the receiver; indicates if it is currently performing asynchronous operations or if all operations have finished/canceled.
   */
  var asyncTransactionContainerState: _AsyncTransactionContainerState { get }
  
  /**
   @summary Cancels all async transactions on the receiver.
   */
  func cancelAsyncTransactions()
  
  var currentAsyncTransaction: _AsyncTransaction? { get set }
  
  
}
