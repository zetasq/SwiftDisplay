//
//  Assert.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/10/29.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

private let mainThreadAssertionsDisabledCountKey = "com.zetasq.SwiftDisplay.mainThreadAssertionsDisabledCountKey"

internal func MainThreadAssertionsAreDisabled() -> Bool {
  return (ThreadLocal<Int>.value(forKey: mainThreadAssertionsDisabledCountKey) ?? 0) > 0
}

internal func PushMainThreadAssertionsDisabled() {
  let count = (ThreadLocal<Int>.value(forKey: mainThreadAssertionsDisabledCountKey) ?? 0) + 1
  ThreadLocal<Int>.setValue(count, forKey: mainThreadAssertionsDisabledCountKey)
}

internal func PopMainThreadAssertionsDisabled() {
  let count = (ThreadLocal<Int>.value(forKey: mainThreadAssertionsDisabledCountKey) ?? 0) - 1
  ThreadLocal<Int>.setValue(count, forKey: mainThreadAssertionsDisabledCountKey)
  
  assert(count >= 0, "Attempt to pop thread assertion-disabling without corresponding push.")
}

internal func DisplayNodeAssertMainThread() {
  assert(MainThreadAssertionsAreDisabled() || pthread_main_np() != 0, "This method must be called on the main thread")
}

internal func DisplayNodeAssertNotMainThread() {
  assert(pthread_main_np() == 0, "This method must be called off the main thread")
}
