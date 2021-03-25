//
//  ADs.swift
//  PangleAd
//
//  Created by my on 2021/3/15.
//

import Foundation
import GeADManager

public extension TaskFactoryCategory {
    static let `default` = "com.pangle.ad.default.task.factory"
    static let express = "com.pangle.ad.express.task.factory"
}
 
extension ADCategory {
    static let splash = "com.pangle.ad.splash.category"
    static let rewardVideo = "com.pangle.ad.rewardVideo.category"
    static let feed = "com.pangle.ad.feed.category"
    static let interstitial = "com.pangle.ad.interstitial.category"
    static let fullScreen = "com.pangle.ad.fullScreen.category"
    static let banner = "com.pangle.ad.banner.category"
}

public enum ImageSize: Int {
    case feed228_150 = 9
    case feed690_388 = 10
}

public enum DefaultADs {
    case splash(slotId: String, frame: CGRect, tolerateTimeout: Double?, hideSkipButton: Bool?)
    case rewardVideo(slotId: String, userId: String, rewardName: String?, rewardAmount: Int?, extra: String?)
    case feed(slotId: String, imageSize: ImageSize, count: Int = 1)
}

extension DefaultADs: ADCompatble {
    public var taskFactoryCategory: TaskFactoryCategory {
        return .default
    }
    
    public var category: ADCategory {
        switch self {
        case .splash:
            return .splash
        case .rewardVideo:
            return .rewardVideo
        case .feed:
            return .feed
        }
    }
}

public enum ExpressADs {
    case rewardVideo(slotId: String, userId: String, rewardName: String?, rewardAmount: Int?, extra: String?)
    case feed(slotId: String, imageSize: ImageSize, count: Int = 1, width: Double, height: Double)
    case interstitial(slotId: String, width: Double, height: Double)
    case fullScreen(slotId: String)
    case banner(slotId: String, interval: Int?, width: Double, height: Double, vc: UIViewController)
}

extension ExpressADs: ADCompatble {
    public var taskFactoryCategory: TaskFactoryCategory {
        return .default
    }
    
    public var category: ADCategory {
        switch self {
        case .rewardVideo:
            return .rewardVideo
        case .feed:
            return .feed
        case .interstitial:
            return .interstitial
        case .fullScreen:
            return .fullScreen
        case .banner:
            return .banner
        }
    }
}
