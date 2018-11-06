//
//  _AsyncTransaction.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/10/29.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation


/**
 @summary ASAsyncTransaction provides lightweight transaction semantics for asynchronous operations.
 
 @desc ASAsyncTransaction provides the following properties:
 
 - Transactions group an arbitrary number of operations, each consisting of an execution block and a completion block.
 - The execution block returns a single object that will be passed to the completion block.
 - Execution blocks added to a transaction will run in parallel on the global background dispatch queues;
 the completion blocks are dispatched to the callback queue.
 - Every operation completion block is guaranteed to execute, regardless of cancelation.
 However, execution blocks may be skipped if the transaction is canceled.
 - Operation completion blocks are always executed in the order they were added to the transaction, assuming the
 callback queue is serial of course.
 */
internal final class _AsyncTransaction: NSObject {
  
  // MARK: - Subtypes
  
  typealias CompletionBlock = (_ completedTransaction: _AsyncTransaction, _ canceled: Bool) -> Void
  
  typealias OperationBlock = () -> Any?
  
  typealias OperationCompletionBlock = (_ value: Any?, _ canceled: Bool) -> Void
  
  /**
   State is initially ASAsyncTransactionStateOpen.
   Every transaction MUST be committed. It is an error to fail to commit a transaction.
   A committed transaction MAY be canceled. You cannot cancel an open (uncommitted) transaction.
   */
  internal enum State {
    case open
    case committed
    case finished
  }
  
  // MARK: - Properties
  /**
   A block that is called when the transaction is completed.
   */
  internal let completionBlock: CompletionBlock?
  
  
  private let _state: Atomic<State> = .init(value: .open)
  
  private let _canceled: Atomic<Bool> = .init(value: false)
  
  /**
   The state of the transaction.
   @see ASAsyncTransactionState
   */
  internal private(set) var state: State {
    get {
      return _state.value
    }
    set {
      _state.value = newValue
    }
  }
  
  private var _operations: [_AsyncTransactionOperation] = []
  
  private let _executionGroup: DispatchGroup = .init()
  
  // MARK: - Init & deinit

  /**
   @summary Initialize a transaction that can start collecting async operations.
   
   @param completionBlock A block that is called when the transaction is completed.
   */
  internal init(completion: CompletionBlock?) {
    self.completionBlock = completion
  }
  
  deinit {
    // Uncommitted transactions break our guarantees about releasing completion blocks on callbackQueue.
    assert(state == .finished, "Unfinished ASAsyncTransactions are not allowed")
  }
  
  // MARK: - Interface methods
  
  /**
   @summary Block the main thread until the transaction is complete, including callbacks.
   
   @desc This must be called on the main thread.
   */
  internal func waitUntilComplete() {
    DisplayNodeAssertMainThread()
    
    if self.state == .open {
      // At this point, the asynchronous operation may have completed, but the runloop
      // observer has not committed the batch of transactions we belong to.  It's important to
      // commit ourselves via the group to avoid double-committing the transaction.
      // This is only necessary when forcing display work to complete before allowing the runloop
      // to continue, e.g. in the implementation of -[ASDisplayNode recursivelyEnsureDisplay].
      
      _AsyncTransactionGroup.main.commit()
      assert(state != .open, "Transaction should not be open after committing group")
    }
    
    _executionGroup.wait()
    _completeTransaction()
  }
  
  /**
   @summary Adds a synchronous operation to the transaction.  The execution block will be executed immediately.
   
   @desc The block will be executed on the specified queue and is expected to complete synchronously.  The async
   transaction will wait for all operations to execute on their appropriate queues, so the blocks may still be executing
   async if they are running on a concurrent queue, even though the work for this block is synchronous.
   
   @param block The execution block that will be executed on a background queue.  This is where the expensive work goes.
   @param priority Execution priority; Tasks with higher priority will be executed sooner
   @param queue The dispatch queue on which to execute the block.
   @param completion The completion block that will be executed with the output of the execution block when all of the
   operations in the transaction are completed. Executed and released on callbackQueue.
   */
  internal func addOperation(_ operationBlock: @escaping OperationBlock, priority: Int, queue: DispatchQueue, completion: OperationCompletionBlock?) {
    DisplayNodeAssertMainThread()
    assert(state == .open, "You can only add operations to open transactions")
    
    let operation = _AsyncTransactionOperation(operationCompletion: completion)
    _operations.append(operation)
    
    _executionGroup.enter()
    _AsyncTransactionQueuePool.randomQueue().async {
      defer {
        self._executionGroup.leave()
      }
      
      autoreleasepool {
        if !self._canceled.value {
          operation.result.value = operationBlock()
        }
      }
    }
    
  }
  
  /**
   @summary Cancels all operations in the transaction.
   
   @desc You can only cancel a committed transaction.
   
   All completion blocks are always called, regardless of cancelation. Execution blocks may be skipped if canceled.
   */
  internal func cancel() {
    DisplayNodeAssertMainThread()
    assert(state != .open, "You can only cancel an already committed transaction")
    
    _canceled.value = true
  }
  
  /**
   @summary Marks the end of adding operations to the transaction.
   
   @desc You MUST commit every transaction you create. It is an error to create a transaction that is never committed.
   
   When all of the operations that have been added have completed the transaction will execute their completion
   blocks.
   
   If no operations were added to this transaction, invoking commit will execute the transaction's completion block synchronously.
   */
  internal func commit() {
    DisplayNodeAssertMainThread()
    assert(state == .open, "You cannot double-commit a transaction")
    
    state = .committed
    
    if _operations.isEmpty {
      // Fast path: if a transaction was opened, but no operations were added, execute completion block synchronously.
      self._completeTransaction()
    } else {
      _executionGroup.notify(queue: .main) {
        self._completeTransaction()
      }
    }
  }
  
  // MARK: - Helper methods
  private func _completeTransaction() {
    DisplayNodeAssertMainThread()
    
    guard state != .finished else {
      return
    }
    
    let isCanceled = _canceled.value
    
    for operation in _operations {
      operation.callAndReleaseCompletionBlock(canceled: isCanceled)
    }
    
    state = .finished
    
    completionBlock?(self, isCanceled)
  }
}
