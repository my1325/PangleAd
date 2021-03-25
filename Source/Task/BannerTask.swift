//
//  BannerTask.swift
//  PangleAd
//
//  Created by my on 2021/3/15.
//

import Foundation
import GeADManager
import BUAdSDK

public final class ExpressBannerTask: NSObject, TaskCompatible {
    public var identifier: String
    
    public var isCanceled: Bool = false
    
    public var ad: ADCompatble
    
    let _ad: BUNativeExpressBannerView
    
    private weak var delegate: TaskReumeResultDelegate?
    
    init(_ slotId: String, interval: Int?, width: Double, height: Double, vc: UIViewController, ad: ADCompatble) {
        let adSize = CGSize(width: width, height: height)

        if let _interval = interval {
            self._ad = BUNativeExpressBannerView(slotID: slotId, rootViewController: vc, adSize: adSize, interval: _interval)
        } else {
            self._ad = BUNativeExpressBannerView(slotID: slotId, rootViewController: vc, adSize: adSize)
        }
        self.identifier = String(format: "%d", Unmanaged.passUnretained(self._ad).toOpaque().hashValue)
        self.ad = ad
        super.init()
        
        self._ad.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self._ad.center = CGPoint(x: width / 2, y: height / 2)
        self._ad.delegate = self
    }
    
    public func cancel() {
        guard !self.isCanceled else { return }
        self.isCanceled = true
    }

    public func resume(_ delegate: TaskReumeResultDelegate) {
        self.delegate = delegate
        self._ad.loadAdData()
    }
    
    public func retry() -> Bool {
        return false
    }
}

extension ExpressBannerTask: BUNativeExpressBannerViewDelegate {
    public func nativeExpressBannerAdViewDidLoad(_ bannerAdView: BUNativeExpressBannerView) {
        delegate?.task(self, adDidLoad: bannerAdView)
    }

    public func nativeExpressBannerAdViewRenderFail(_ bannerAdView: BUNativeExpressBannerView, error: Error?) {
        delegate?.task(self, didCompleteWithError: (error as NSError?) ?? NSError(domain: "com.pangle.task.intersitial.ad.fail", code: -1, userInfo: nil))
    }

    public func nativeExpressBannerAdView(_ bannerAdView: BUNativeExpressBannerView, didLoadFailWithError error: Error?) {
        delegate?.task(self, didCompleteWithError: (error as NSError?) ?? NSError(domain: "com.pangle.task.intersitial.ad.fail", code: -1, userInfo: nil))
    }

    public func nativeExpressBannerAdView(_ bannerAdView: BUNativeExpressBannerView, dislikeWithReason filterwords: [BUDislikeWords]?) {
        delegate?.task(self, didCompleteWithData: ["ad": bannerAdView, "info": filterwords ?? []])
    }

    public func nativeExpressBannerAdViewRenderSuccess(_ bannerAdView: BUNativeExpressBannerView) {
    }
}
