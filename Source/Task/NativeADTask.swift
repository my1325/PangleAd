//
//  NativeAdTask.swift
//  pangle_flutter
//
//  Created by my on 2021/3/12.
//

import Foundation
import GeADManager
import BUAdSDK

public final class NativeADTask: NSObject, TaskCompatible {
    public var identifier: String
    
    public var isCanceled: Bool = false
    
    public var ad: ADCompatble
    
    let _ad: BUNativeAdsManager
    
    let _count: Int
    
    private weak var delegate: TaskReumeResultDelegate?
    
    init(_ slotId: String, imageSize: Int, count: Int, ad: ADCompatble) {
        let _ad = BUNativeAdsManager()
        let slot = BUAdSlot()
        slot.id = slotId
        slot.adType = .feed
        slot.position = .feed
        slot.imgSize = BUSize(by: BUProposalSize(rawValue: imageSize)!)
        _ad.adslot = slot
        self.identifier = String(format: "%d", Unmanaged.passUnretained(_ad).toOpaque().hashValue)
        self._count = count
        self._ad = _ad
        self.ad = ad
        super.init()
        self._ad.delegate = self
    }
    
    public func cancel() {
        guard !isCanceled else { return }
        isCanceled = true
    }

    public func resume(_ delegate: TaskReumeResultDelegate) {
        self.delegate = delegate
        self._ad.loadAdData(withCount: _count)
    }
    
    public func retry() -> Bool {
        return false
    }
}

extension NativeADTask: BUNativeAdsManagerDelegate {
    public func nativeAdsManager(_ adsManager: BUNativeAdsManager, didFailWithError error: Error?) {
        self.delegate?.task(self, didCompleteWithError: (error as NSError?) ?? NSError(domain: "com.pangle.task.intersitial.ad.fail", code: -1, userInfo: nil))
    }

    public func nativeAdsManagerSuccess(toLoad adsManager: BUNativeAdsManager, nativeAds nativeAdDataArray: [BUNativeAd]?) {
        self.delegate?.task(self, adDidLoad: nativeAdDataArray)
        self.delegate?.task(self, didCompleteWithData: nil)
    }
}

public final class ExpressNativeADTask: NSObject, TaskCompatible {
    public var identifier: String
    
    public var isCanceled: Bool = false 
    
    public var ad: ADCompatble
    
    let _ad: BUNativeExpressAdManager
    
    let _count: Int
    
    private weak var delegate: TaskReumeResultDelegate?
    
    init(_ slotId: String, count: Int, imageSize: Int, width: Double, height: Double, ad: ADCompatble) {
        let imgSize = BUSize(by: BUProposalSize(rawValue: imageSize)!)!
        let adSize = CGSize(width: width, height: height)
        
        let slot = BUAdSlot()
        slot.id = slotId
        slot.adType = .feed
        slot.position = .feed
        slot.imgSize = imgSize
        
        let _ad = BUNativeExpressAdManager(slot: slot, adSize: adSize)
        _ad.adSize = adSize
        self.identifier = String(format: "%d", Unmanaged.passUnretained(_ad).toOpaque().hashValue)
        self._count = count
        self._ad = _ad
        self.ad = ad
        super.init()
        self._ad.delegate = self
    }
    
    public func cancel() {
        guard !isCanceled else { return }
        isCanceled = true
    }

    public func resume(_ delegate: TaskReumeResultDelegate) {
        self.delegate = delegate
        self._ad.loadAdData(withCount: _count)
    }
    
    public func retry() -> Bool {
        return false
    }
}

extension ExpressNativeADTask: BUNativeExpressAdViewDelegate {
    public func nativeExpressAdSuccess(toLoad nativeExpressAd: BUNativeExpressAdManager, views: [BUNativeExpressAdView]) {
        views.forEach({
            $0.delegate = self
            $0.manager = nativeExpressAd
        })
        self.delegate?.task(self, adDidLoad: views)
        self.delegate?.task(self, didCompleteWithData: views)
    }

    public func nativeExpressAdFail(toLoad nativeExpressAd: BUNativeExpressAdManager, error: Error?) {
        self.delegate?.task(self, didCompleteWithError: (error as NSError?) ?? NSError(domain: "com.pangle.task.intersitial.ad.fail", code: -1, userInfo: nil))
    }

    public func nativeExpressAdViewRenderFail(_ nativeExpressAdView: BUNativeExpressAdView, error: Error?) {
        self.delegate?.task(self, didCompleteWithError: (error as NSError?) ?? NSError(domain: "com.pangle.task.intersitial.ad.fail", code: -1, userInfo: nil))
    }

    public func nativeExpressAdViewRenderSuccess(_ nativeExpressAdView: BUNativeExpressAdView) {
        self.delegate?.task(self, didCompleteWithData: nativeExpressAdView)
    }

    public func nativeExpressAdView(_ nativeExpressAdView: BUNativeExpressAdView, dislikeWithReason filterWords: [BUDislikeWords]) {
        nativeExpressAdView.didReceiveDislike?(filterWords)
    }
}

private var managerKey = "com.my.pangle.ad.express.native.view.manager"
private var delegateKey = "com.my.pangle.ad.express.native.view.delegate"
private var dislikeDelegateKey = "com.my.pangle.ad.express.native.view.dislike"

extension BUNativeExpressAdView {
    var manager: BUNativeExpressAdManager? {
        get {
            return objc_getAssociatedObject(self, &managerKey) as? BUNativeExpressAdManager
        } set {
            objc_setAssociatedObject(self, &managerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var delegate: BUNativeExpressAdViewDelegate? {
        get {
            return objc_getAssociatedObject(self, &delegateKey) as? BUNativeExpressAdViewDelegate
        } set {
            objc_setAssociatedObject(self, &delegateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 设置dislike的点击事件
    var didReceiveDislike: (([BUDislikeWords]) -> Void)? {
        get {
            objc_getAssociatedObject(self, &dislikeDelegateKey) as? (([BUDislikeWords]) -> Void)
        } set {
            objc_setAssociatedObject(self, &dislikeDelegateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
