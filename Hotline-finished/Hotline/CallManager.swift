/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import CallKit

class CallManager {
  
  var callsChangedHandler: (() -> Void)?
  
  private(set) var calls = [Call]()
  private let callController = CXCallController()
  //这个方法将一个CXStartCallAction放到CXTransaction中，然后向系统发起请求。
  func startCall(handle: String, videoEnabled: Bool) {
    //一个CXHandle对象表示了一次操作，同时指定了操作的类型和值.Hotline App支持对电话号码进行操作，因此我们在操作中指定了电话号码。
    let handle = CXHandle(type: .phoneNumber, value: handle)
    //一个CXStartCallAction用一个UUID和一个操作作为输入。
    let startCallAction = CXStartCallAction(call: UUID(), handle: handle)
    //你可以通过action的isVideo属性指定通话是音频还是视频。
    startCallAction.isVideo = videoEnabled
    let transaction = CXTransaction(action: startCallAction)
    
    requestTransaction(transaction)
  }
  
  func end(call: Call) {
    //先创建一个CXEndCallAction。将通话的UUID传递给构造函数，以便在后面可以识别通话。
    let endCallAction = CXEndCallAction(call: call.uuid)
    //然后将操作封装成CXTransaction，以便发送给系统。
    let transaction = CXTransaction(action: endCallAction)
    
    requestTransaction(transaction)
  }
  //后者封装在transaction中的是一个CXSetHeldCallAction对象。这个action包含了通话的UUID以及保持状态
  func setHeld(call: Call, onHold: Bool) {
    let setHeldCallAction = CXSetHeldCallAction(call: call.uuid, onHold: onHold)
    let transaction = CXTransaction()
    transaction.addAction(setHeldCallAction)
    
    requestTransaction(transaction)
  }
  //系统会请求CXProvider执行这个CXTransaction，这会导致刚刚实现的委托方法被调用
  private func requestTransaction(_ transaction: CXTransaction) {
    callController.request(transaction) { error in
      if let error = error {
        print("Error requesting transaction: \(error)")
      } else {
        print("Requested transaction successfully")
      }
    }
  }
  
  func callWithUUID(uuid: UUID) -> Call? {
    guard let index = calls.index(where: { $0.uuid == uuid }) else {
      return nil
    }
    return calls[index]
  }
  
  func add(call: Call) {
    calls.append(call)
    call.stateChanged = { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.callsChangedHandler?()
    }
    callsChangedHandler?()
  }
  
  func remove(call: Call) {
    guard let index = calls.index(where: { $0 === call }) else { return }
    calls.remove(at: index)
    callsChangedHandler?()
  }
  
  func removeAllCalls() {
    calls.removeAll()
    callsChangedHandler?()
  }
}
