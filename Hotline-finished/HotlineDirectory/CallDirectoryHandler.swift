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

class CallDirectoryHandler: CXCallDirectoryProvider {
  //这个方法在扩展被初始化时调用。如果发生错误，扩展会告诉宿主App取消这个扩展请求（通过调用cancelRequest（withError :)方法）
  override func beginRequest(with context: CXCallDirectoryExtensionContext) {
    context.delegate = self
    
    do {
      try addBlockingPhoneNumbers(to: context)
    } catch {
      NSLog("Unable to add blocking phone numbers")
      let error = NSError(domain: "CallDirectoryHandler", code: 1, userInfo: nil)
      context.cancelRequest(withError: error)
      return
    }
    
    do {
      try addIdentificationPhoneNumbers(to: context)
    } catch {
      NSLog("Unable to add identification phone numbers")
      let error = NSError(domain: "CallDirectoryHandler", code: 2, userInfo: nil)
      context.cancelRequest(withError: error)
      return
    }
    
    context.completeRequest()
  }
  
  // 1.方法用于定义要阻塞的电话号码
  private func addBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) throws {
    let phoneNumbers: [CXCallDirectoryPhoneNumber] = [ 1234 ]
    
    for phoneNumber in phoneNumbers {
        //将这个号码添加到黑名单。当某个号码被阻塞，系统电话提供商不会显示任何来自这个号码的来电。
      context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
    }
  }
  
  // 2.
  private func addIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) throws {
    let phoneNumbers: [CXCallDirectoryPhoneNumber] = [ 1111 ]
    let labels = [ "RW Tutorial Team" ]
    
    for (phoneNumber, label) in zip(phoneNumbers, labels) {
     //将某个号码和标签作为参数调用addIdentificationEntry（withNextSequentialPhoneNumber：label :)方法将创建一个新的标识条目。当系统收到这个号码的来电时，电话UI上会显示这个标签给用户
        context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: label)
    }
  }
  
}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {
  
  func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
    print("An error occured when completing the request: \(error.localizedDescription)")
  }
  
}
