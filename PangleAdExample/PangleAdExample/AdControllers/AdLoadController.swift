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

    private lazy var immediatelyButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("load", for: .normal)
        $0.setTitleColor(UIColor.ge.color(with: "ffffff"), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        $0.setBackgroundImage(UIImage.ge.image(withColor: UIColor.red, size: CGSize(width: 50, height: 30)), for: .normal)
        $0.setBackgroundImage(UIImage.ge.image(withColor: UIColor.lightGray, size: CGSize(width: 50, height: 30)), for: .disabled)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        self.view.addSubview($0)
        $0.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX).offset(0)
            make.centerY.equalTo(self.view.snp.centerY).offset(0)
            make.width.equalTo(100)
            make.height.equalTo(30)
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

        immediatelyButton.ge.tap { [weak self] _ in
            self?.handleImmediatelyAction()
        }
    }
    
    func handleImmediatelyAction() {
        let ad = immediatelyAd()
        ADManager.shared.requestPangleAd(ad, adDidLoad: { [weak self] in
            self?.handleAd(ad, didLoadWithData: $0)
        }, complete: { [weak self] in
            self?.handleAdDidComplete(ad, $0)
        })
    }
    
    private func immediatelyAd() -> ADCompatble {
        switch category {
        case .default:
            return defaultAd()
        case .express:
            return expressAd()
        }
    }
    
    private func defaultAd() -> DefaultADs {
        switch ad {
        case .splash:
            return .splash(slotId: kSplashId, frame: UIScreen.main.bounds, tolerateTimeout: nil, hideSkipButton: nil)
        case .fullscreen, .intersitial, .banner:
            fatalError("not support ad \(ad)")
        case .videoReward:
            return .rewardVideo(slotId: kRewardedVideoId, userId: "", rewardName: nil, rewardAmount: nil, extra: nil)
        case .feed:
            return .feed(slotId: kFeedId, imageSize: .feed228_150, count: 3)
        }
    }
    
    private func expressAd() -> ExpressADs {
        switch ad {
        case .splash:
            fatalError("not support ad \(ad)")
        case .fullscreen:
            return .fullScreen(slotId: kFullscreenVideoExpressId)
        case .videoReward:
            return .rewardVideo(slotId: kRewardedVideoExpressId, userId: "", rewardName: nil, rewardAmount: nil, extra: nil)
        case .feed:
            return .feed(slotId: kFeedVideoExpressId, imageSize: .feed690_388, count: 3, width: 375, height: 284)
        case .intersitial:
            return .interstitial(slotId: kInterstitialExpressId, width: 345, height: 207)
        case .banner:
            return .banner(slotId: kBannerExpressId, interval: nil, width: 375, height: 125, vc: self)
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
            navigationController?.pushViewController(LoadFeedAdController(_data), animated: true)
        case .splash where data is BUSplashAdView:
            let _splashView = data as! BUSplashAdView
            navigationController?.view.addSubview(_splashView)
            _splashView.rootViewController = self
        case .rewardVideo where data is BURewardedVideoAd:
            let _ad = data as! BURewardedVideoAd
            _ad.show(fromRootViewController: self)
        default:
            fatalError("something wrong")
        }
    }
    
    private func handleExpressAd(_ ad: ExpressADs, didLoadWithData data: Any?) {
        switch ad {
        case .rewardVideo where data is BUNativeExpressRewardedVideoAd:
            let _ad = data as! BUNativeExpressRewardedVideoAd
            _ad.show(fromRootViewController: self)
        case .feed:
            break
        case .interstitial where data is BUNativeExpressInterstitialAd:
            let _ad = data as! BUNativeExpressInterstitialAd
            _ad.show(fromRootViewController: self)
        case .fullScreen where data is BUNativeExpressFullscreenVideoAd:
            let _ad = data as! BUNativeExpressFullscreenVideoAd
            _ad.show(fromRootViewController: self)
        case .banner where data is BUNativeExpressBannerView:
            let _ad = data as! BUNativeExpressBannerView
            view.addSubview(_ad)
        default:
            fatalError("not support ad \(ad)")
        }
    }
    
    private func handleAdDidComplete(_ ad: ADCompatble, _ result: Result<Any?, NSError>) {
        if let _ad = ad as? DefaultADs {
            handleDefaultADComplete(_ad, result)
        } else if let _ad = ad as? ExpressADs {
            handleDefaultExpressAdComplete(_ad, result)
        } else {
            fatalError("not support ad \(ad)")
        }
    }
    
    private func handleDefaultADComplete(_ ad: DefaultADs, _ result: Result<Any?, NSError>) {
        switch (ad, result) {
        case (.feed, .success(let data)):
            let _data = data as! [BUNativeExpressAdView]
            break
        case (.splash, .success(let data)) where data is [String: Any]:
            if let userInfo = data as? [String: Any], let ad = userInfo["ad"] as? BUSplashAdView {
//                ad.removeFromSuperview()
            }
        case (.rewardVideo, .success(let data)):
            if let userInfo = data as? [String: Any], let _ad = userInfo["ad"] as? BURewardedVideoAd {
//                _ad.show(fromRootViewController: self)
            }
        case (_, .failure(let error)):
            print("\(ad) complete with Error \(error)")
        default:
            fatalError("not support ad \(ad)")
        }
    }
    
    private func handleDefaultExpressAdComplete(_ ad: ExpressADs, _ result: Result<Any?, NSError>) {
        switch (ad, result) {
        case (.feed, .success(let data)):
            break
        case (.rewardVideo, .success(let data)) where data is [String: Any]:
            if let userInfo = data as? [String: Any], let ad = userInfo["ad"] as? BUNativeExpressRewardedVideoAd {
//                ad.remove
            }
        case (.interstitial, .success(let data)) where data is [String: Any]:
            if let userInfo = data as? [String: Any], let ad = userInfo["ad"] as? BUNativeExpressInterstitialAd {

            }
        case (.fullScreen, .success(let data)) where data is [String: Any]:
            if let userInfo = data as? [String: Any], let ad = userInfo["ad"] as? BUNativeExpressFullscreenVideoAd {

            }
        case (.banner, .success(let data)) where data is [String: Any]:
            if let userInfo = data as? [String: Any], let ad = userInfo["ad"] as? BUNativeExpressBannerView {
                ad.removeFromSuperview()
            }
        case (_, .failure(let error)):
            print("\(ad) complete with Error \(error)")
        default:
            fatalError("not support ad \(ad)")
        }
    }
}
