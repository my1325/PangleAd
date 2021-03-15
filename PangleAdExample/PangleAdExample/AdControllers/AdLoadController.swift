//
//  BaseAdLoadController.swift
//  PangleAdExample
//
//  Created by my on 2021/3/15.
//

import UIKit
import GeSwift
import PangleAd
import ADManager
import BUAdSDK

internal class AdLoadController: BaseViewController {
    private lazy var preloadButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("preload", for: .normal)
        $0.setTitleColor(UIColor.ge.color(with: "ffffff"), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        $0.backgroundColor = UIColor.green
        $0.setBackgroundImage(UIImage.ge.image(withColor: UIColor.green, size: CGSize(width: 50, height: 30)), for: .normal)
        self.view.addSubview($0)
        $0.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX).offset(0)
            make.top.equalTo(150)
        }
        return $0
    }(UIButton(type: .custom))

    private lazy var immediatelyButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("immediately", for: .normal)
        $0.setTitleColor(UIColor.ge.color(with: "ffffff"), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        $0.isEnabled = false
        $0.setBackgroundImage(UIImage.ge.image(withColor: UIColor.green, size: CGSize(width: 50, height: 30)), for: .normal)
        $0.setBackgroundImage(UIImage.ge.image(withColor: UIColor.lightGray, size: CGSize(width: 50, height: 30)), for: .disabled)
        self.view.addSubview($0)
        $0.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX).offset(0)
            make.top.equalTo(150)
        }
        return $0
    }(UIButton(type: .custom))
    
    enum Category {
        case `default`
        case express
    }
    
    let ad: ADList
    let category: Category
    init(ad: ADList, category: Category) {
        self.ad = ad
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        preloadButton.ge.tap { [weak self] _ in
            self?.handlePreloadAction()
        }
        
        immediatelyButton.ge.tap { [weak self] _ in
            self?.handleImmediatelyAction()
        }
    }
    
    func handlePreloadAction() {
        let ad = preloadAd()
        ADManager.shared.requestPangleAd(ad, adDidLoad: { [weak self] in
            self?.handleAd(ad, didLoadWithData: $0)
        }, complete: { _ in
            
        })
    }
    
    func handleImmediatelyAction() {
        print("class \(self) not override method \(#function)")
    }
    
    private func preloadAd() -> ADCompatble {
        switch category {
        case .default:
            return preloadDefaultAd()
        case .express:
            return preloadExpressAd()
        }
    }
    
    private func preloadDefaultAd() -> DefaultADs {
        switch ad {
        case .splash:
            return .splash(method: .preload, slotId: kSplashId, frame: UIScreen.main.bounds, tolerateTimeout: nil, hideSkipButton: nil)
        case .fullscreen, .intersitial, .banner:
            fatalError("not support ad \(ad)")
        case .videoReward:
            return .rewardVideo(method: .preload, slotId: kRewardedVideoId, userId: "", rewardName: nil, rewardAmount: nil, extra: nil)
        case .feed:
            return .feed(method: .preload, slotId: kFeedId, imageSize: .feed228_150, count: 3)
        }
    }
    
    private func preloadExpressAd() -> ExpressADs {
        switch ad {
        case .splash:
            fatalError("not support ad \(ad)")
        case .fullscreen:
            return .fullScreen(method: .preload, slotId: kSplashId)
        case .videoReward:
            return .rewardVideo(method: .preload, slotId: kRewardedVideoExpressId, userId: "", rewardName: nil, rewardAmount: nil, extra: nil)
        case .feed:
            return .feed(method: .preload, slotId: kFeedVideoExpressId, imageSize: .feed690_388, count: 3, width: 375, height: 284)
        case .intersitial:
            return .interstitial(method: .preload, slotId: kInterstitialExpressId, width: 345, height: 207)
        case .banner:
            return .banner(method: .preload, slotId: kBannerExpressId, interval: nil, width: 375, height: 125, vc: self)
        }
    }
}

extension AdLoadController {
    
    private func handleAd(_ ad: ADCompatble, didLoadWithData data: Any?) {
        if let _ad = ad as? DefaultADs {
            handleDefaultAd(_ad, didLoadWithData: data)
        } else if let _ad = ad as? ExpressADs {
            handleExpressAd(_ad, didLoadWithData: data)
        } else {
            fatalError("not support ad \(ad)")
        }
    }
    
    private func handleDefaultAd(_ ad: DefaultADs, didLoadWithData data: Any?) {
        switch ad {
        case .feed where data is [BUNativeExpressAdView]:
            let _data = data as! [BUNativeExpressAdView]
            
        }
    }
    
    private func handleExpressAd(_ ad: ExpressADs, didLoadWithData data: Any?) {
        
    }
}
