//
//  SplashADTask.swift
//  pangle_flutter
//
//  Created by my on 2021/3/12.
//

import ADManager
import BUAdSDK
import Foundation

public final class SplashADTask: NSObject, TaskCompatible {
    public var identifier: String
    
    public var isCanceled: Bool = false
    
    public var ad: ADCompatble
    
    let _ad: BUSplashAdView
    
    private weak var delegate: TaskReumeResultDelegate?
    
    init(_ slotId: String, frame: CGRect, tolerateTimeout: Double?, hideSkipButton: Bool?, ad: ADCompatble) {
        let splashView = BUSplashAdView(slotID: slotId, frame: frame)
        if tolerateTimeout != nil {
            splashView.tolerateTimeout = tolerateTimeout!
        }
        if hideSkipButton != nil {
            splashView.hideSkipButton = hideSkipButton!
        }
        self.identifier = String(format: "%d", Unmanaged.passUnretained(splashView).toOpaque().hashValue)
        self._ad = splashView
        self.ad = ad
        super.init()
        self._ad.delegate = self
    }
    
    public func cancel() {
        guard !self.isCanceled else { return }
        self.isCanceled = true
    }

    public func resume(_ delegate: TaskReumeResultDelegate) {
        self.delegate = delegate
        self._ad.loadAdData()
        self.delegate?.task(self, adDidLoad: self._ad)
    }
    
    public func retry() -> Bool {
        return false
    }
    
    deinit {
        print("----------\(self) deinit--------")
    }
}

extension SplashADTask: BUSplashAdDelegate {
    public func splashAdDidClick(_ splashAd: BUSplashAdView) {
        self.delegate?.task(self, didCompleteWithData: ["ad": splashAd, "info": "click"])
    }
    
    public func splashAdDidClickSkip(_ splashAd: BUSplashAdView) {
        self.delegate?.task(self, didCompleteWithData: ["ad": splashAd, "info": "skip"])
    }
    
    public func splashAdDidClose(_ splashAd: BUSplashAdView) {
        self.delegate?.task(self, didCompleteWithData: ["ad": splashAd, "info": "close"])
    }
    
    public func splashAd(_ splashAd: BUSplashAdView, didFailWithError error: Error?) {
        self.delegate?.task(self, didCompleteWithError: (error as NSError?) ?? NSError(domain: "com.pangle.task.intersitial.ad.fail", code: -1, userInfo: nil))
    }
    
    public func splashAdCountdown(toZero splashAd: BUSplashAdView) {
        self.delegate?.task(self, didCompleteWithData: ["ad": splashAd, "info": "count down"])
    }
}

public final class ExpressSplashADTask: NSObject, TaskCompatible {
    public var identifier: String
    
    public var isCanceled: Bool = false
    
    public var ad: ADCompatble
    
    let _ad: BUNativeExpressSplashView
    
    private weak var delegate: TaskReumeResultDelegate?
    
    init(_ slotId: String, width: Double, height: Double, tolerateTimeout: Double?, hideSkipButton: Bool?, vc: UIViewController, ad: ADCompatble) {
        let adSize = CGSize(width: width, height: height)
        let splashView = BUNativeExpressSplashView(slotID: slotId, adSize: adSize, rootViewController: vc)
        if tolerateTimeout != nil {
            splashView.tolerateTimeout = tolerateTimeout!
        }
        if hideSkipButton != nil {
            splashView.hideSkipButton = hideSkipButton!
        }
        self.identifier = String(format: "%d", Unmanaged.passUnretained(splashView).toOpaque().hashValue)
        self._ad = splashView
        self.ad = ad
        super.init()
        self._ad.delegate = self
    }
    
    public func cancel() {
        guard !self.isCanceled else { return }
        self.isCanceled = true
    }

    public func resume(_ delegate: TaskReumeResultDelegate) {
        self.delegate = delegate
        self._ad.loadAdData()
        self.delegate?.task(self, adDidLoad: self._ad)
    }
    
    public func retry() -> Bool {
        return false
    }
}

extension ExpressSplashADTask: BUNativeExpressSplashViewDelegate {
    public func nativeExpressSplashViewDidClick(_ splashAdView: BUNativeExpressSplashView) {
        self.delegate?.task(self, didCompleteWithData: ["ad": splashAdView, "info": "click"])
    }
    
    public func nativeExpressSplashViewDidClickSkip(_ splashAdView: BUNativeExpressSplashView) {
        self.delegate?.task(self, didCompleteWithData: ["ad": splashAdView, "info": "skip"])
    }
    
    public func nativeExpressSplashViewDidClose(_ splashAdView: BUNativeExpressSplashView) {
        self.delegate?.task(self, didCompleteWithData: ["ad": splashAdView, "info": "close"])
    }
    
    public func nativeExpressSplashView(_ splashAdView: BUNativeExpressSplashView, didFailWithError error: Error?) {
        self.delegate?.task(self, didCompleteWithError: (error as NSError?) ?? NSError(domain: "com.pangle.task.intersitial.ad.fail", code: -1, userInfo: nil))
    }
    
    public func nativeExpressSplashViewRenderFail(_ splashAdView: BUNativeExpressSplashView, error: Error?) {
        self.delegate?.task(self, didCompleteWithError: (error as NSError?) ?? NSError(domain: "com.pangle.task.intersitial.ad.fail", code: -1, userInfo: nil))
    }
    
    public func nativeExpressSplashViewDidLoad(_ splashAdView: BUNativeExpressSplashView) {}
    
    public func nativeExpressSplashViewRenderSuccess(_ splashAdView: BUNativeExpressSplashView) {}
    
    public func nativeExpressSplashViewWillVisible(_ splashAdView: BUNativeExpressSplashView) {}
    
    public func nativeExpressSplashViewCountdown(toZero splashAdView: BUNativeExpressSplashView) {}
    
    public func nativeExpressSplashViewFinishPlayDidPlayFinish(_ splashView: BUNativeExpressSplashView, didFailWithError error: Error) {}
    
    public func nativeExpressSplashViewDidCloseOtherController(_ splashView: BUNativeExpressSplashView, interactionType: BUInteractionType) {}
}
