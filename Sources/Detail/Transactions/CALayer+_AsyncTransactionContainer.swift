//
//  CALayer+_AsyncTransactionContainer.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/10/30.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
  
  /**
   @summary Returns the current async transaction for this layer. A new transaction is created if one
   did not already exist. This method will always return an open, uncommitted transaction.
   @desc asyncdisplaykit_asyncTransactionContainer does not need to be YES for this to return a transaction.
   Defaults to nil.
   */
  var asyncTransaction: _AsyncTransaction {
    let transaction: _AsyncTransaction
    
    if let currentTransaction = self.currentAsyncTransaction {
      transaction = currentTransaction
    } else {
      let transactions = self.asyncLayerTransactions
      
      transaction = _AsyncTransaction(completion: { [weak self] completedTransaction, canceled in
        guard let self = self else { return }
        
        transactions.remove(completedTransaction)
        self.asyncTransactionContainerDidCompleteTransaction(completedTransaction)
      })
      
      transactions.add(transaction)
      
      self.currentAsyncTransaction = transaction
      self.asyncTransactionContainerWillBeginTransaction(transaction)
    }
    
    _AsyncTransactionGroup.main.addTransactionContainer(self)
    
    return transaction
  }
  
  /**
   @summary Goes up the superlayer chain until it finds the first layer with asyncdisplaykit_asyncTransactionContainer=YES (including the receiver) and returns it.
   Returns nil if no parent container is found.
   */
  var parentTransactionContainer: CALayer? {
    var containerLayer: CALayer? = self
    
    while containerLayer != nil && !containerLayer!.isAsyncTransactionContainer {
      containerLayer = containerLayer?.superlayer
    }
    
    return containerLayer
  }
  
  var asyncLayerTransactions: NSHashTable<_AsyncTransaction> {
    get {
      if let existingTable = self.value(forKey: #function) as? NSHashTable<_AsyncTransaction> {
        return existingTable
      } else {
        let table = NSHashTable<_AsyncTransaction>(options: .objectPointerPersonality)
        self.setValue(table, forKey: #function)
        return table
      }
    }
  }
  
  @objc
  func asyncTransactionContainerWillBeginTransaction(_ transaction: _AsyncTransaction) {
    // No-ops in the base class. Mostly exposed for testing.
  }
  
  @objc
  func asyncTransactionContainerDidCompleteTransaction(_ transaction: _AsyncTransaction) {
    // No-ops in the base class. Mostly exposed for testing.
  }
  
}

extension CALayer: _AsyncTransactionContainer {
  
  /**
   @summary Whether or not this layer should serve as a transaction container.
   Defaults to NO.
   */
  var isAsyncTransactionContainer: Bool {
    get {
      return (self.value(forKey: #function) as? Bool) ?? false
    }
    set {
      self.setValue(newValue, forKey: #function)
    }
  }
  
  var asyncTransactionContainerState: _AsyncTransactionContainerState {
    if self.asyncLayerTransactions.count == 0 {
      return .noTransactions
    } else {
      return .pendingTransactions
    }
  }
  
  func cancelAsyncTransactions() {
    // If there was an open transaction, commit and clear the current transaction. Otherwise:
    // (1) The run loop observer will try to commit a canceled transaction which is not allowed
    // (2) We leave the canceled transaction attached to the layer, dooming future operations
    if let currentTransaction = self.currentAsyncTransaction {
      currentTransaction.commit()
    }
    
    self.currentAsyncTransaction = nil
    
    for transaction in self.asyncLayerTransactions.allObjects {
      transaction.cancel()
    }
  }
  
  var currentAsyncTransaction: _AsyncTransaction? {
    get {
      return self.value(forKey: #function) as? _AsyncTransaction
    }
    set {
      self.setValue(newValue, forKey: #function)
    }
  }
  
  
}
