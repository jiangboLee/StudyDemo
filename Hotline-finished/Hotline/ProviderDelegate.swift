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

import CallKit
import AVFoundation

class ProviderDelegate: NSObject {
  
  fileprivate let callManager: CallManager
  fileprivate let provider: CXProvider
  
  init(callManager: CallManager) {
    self.callManager = callManager
    provider = CXProvider(configuration: type(of: self).providerConfiguration)
    
    super.init()
    
    provider.setDelegate(self, queue: nil)
  }
//CXProviderConfiguration支持视频通话，电话号码处理，并将通话群组的数字限制为1个
  static var providerConfiguration: CXProviderConfiguration {
    let providerConfiguration = CXProviderConfiguration(localizedName: "")
    
    providerConfiguration.supportsVideo = true
    providerConfiguration.maximumCallsPerCallGroup = 1
    providerConfiguration.supportedHandleTypes = [.phoneNumber]
    
    return providerConfiguration
  }
  //允许App通过CXProvider API来报告一个来电
  func reportIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false, completion: ((NSError?) -> Void)?) {
    //准备向系统报告一个呼叫更新事件，它包含了所有的来电相关的元数据。
    let update = CXCallUpdate()
    update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)
    update.hasVideo = hasVideo
    //调用CXProvider的reportIcomingCall（with：update：completion :)方法通知系统有来电。
    provider.reportNewIncomingCall(with: uuid, update: update) { error in
      if error == nil {
        //完成回调会在系统处理来电时调用。如果没有任何错误，你会创建一个Call实例，将它添加到CallManager的通话列表中。
        let call = Call(uuid: uuid, handle: handle)
        self.callManager.add(call: call)
      }
      //调用完成块，如果它不为空的话。
        completion?(error as NSError?)
    }
  }
}

// MARK: - CXProviderDelegate
//CXProviderDelegate只实现一个必须的方法，providerDidReset（_ :)。当CXProvider被reset时，这个方法被调用，这样你的App就可以清空所有去电，会到干净的状态。在这个方法中，你会停止所有的呼出音频会话，然后抛弃所有激活的通话。
extension ProviderDelegate: CXProviderDelegate {
  func providerDidReset(_ provider: CXProvider) {
    stopAudio()
    
    for call in callManager.calls {
      call.end()
    }
    
    callManager.removeAllCalls()
  }
  
  func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
    //从callManager中获得一个引用，UUID指定为要接听的动画的UUID。
    guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
      action.fail()
      return
    }
    //设置通话要用的音频会话是App的责任。系统会以一个较高的优先级来激活这个会话。
    configureAudioSession()
    //通过调用answer，你会表明这个通话现在激活
    call.answer()
    //如果处理过程中没有发生错误，你可以调用fullfill（）表示成功。
    action.fulfill()
  }
  //当系统激活CXProvider的音频会话时，委托会被调用。这给你一个机会开始处理通话的音频
  func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
    guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
      action.fail()
      return
    }
    //当电话即将结束时，停止这次通话的音频处理。
    stopAudio()
    //调用end（）方法修改本次通话的状态，以允许其他类和新的状态交互。
    call.end()
   // 将行动标记为履行。
    action.fulfill()
    //当你不需要要这个通话时，可以让CallManager回收它。
    callManager.remove(call: call)
  }
  
  func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
    guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
      action.fail()
      return
    }
    //获得CXCall对象之后，我们要根据action的isOnHold属性来设置它的状态。
    call.state = action.isOnHold ? .held : .active
    //根据状态的不同，分别进行启动或停止音频会话。
    if call.state == .held {
      stopAudio()
    } else {
      startAudio()
    }
    //标记行动为履行。
    action.fulfill()
  }
  //处理呼出通话
  func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
    //当我们用UUID创建出Call对象之后，我们就应该去配置App的音频会话。和呼入通话一样，你的唯一任务就是配置。真正的处理在后面进行，也就是在提供者（_：didActivate）委托方法被调用时。
    let call = Call(uuid: action.callUUID, outgoing: true, handle: action.handle.value)
    configureAudioSession()
    //它会监听通话的生命周期。它首先会会报告的就是呼出通话开始连接。当通话最终连上时，代表也会被通知。
    call.connectedStateChanged = { [weak self] in
      guard let strongSelf = self else { return }
      
      if case .pending = call.connectedState {
        strongSelf.provider.reportOutgoingCall(with: call.uuid, startedConnectingAt: nil)
      } else if case .complete = call.connectedState {
        strongSelf.provider.reportOutgoingCall(with: call.uuid, connectedAt: nil)
      }
    }
    //调用call.start（）方法会导致call的生命周期变化。如果连接成功，则标记action为fullfill。
    call.start { [weak self] success in
      guard let strongSelf = self else { return }
      
      if success {
        action.fulfill()
        strongSelf.callManager.add(call: call)
      } else {
        action.fail()
      }
    }
  }
  
  func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
    startAudio()
  }
}
