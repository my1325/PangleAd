//
//  ADs.swift
//  PangleAd
//
//  Created by my on 2021/3/15.
//

import Foundation
import ADManager

public extension TaskFactoryCategory {
    static let `default` = "com.pangle.ad.default.task.factory"
    static let express = "com.pangle.ad.express.task.factory"
}

public extension ADCategory {
    static let splash = "com.pangle.ad.splash.category"
    static let rewardVideo = "com.pangle.ad.rewardVideo.category"
    static let feed = "com.pangle.ad.feed.category"
    static let interstitial = "com.pangle.ad.interstitial.category"
    static let fullScreen = "com.pangle.ad.fullScreen.category"
}

public enum DefaultADs {
    case splash(method: LoadMethod, slotId: String, frame: CGRect, tolerateTimeout: Double?, hideSkipButton: Bool?)
    case rewardVideo(method: LoadMethod, slotId: String, userId: String, rewardName: String?, rewardAmount: Int?, extra: String?)
    case feed(method: LoadMethod, slotId: String, imageSize: Int, count: Int = 1)
    case interstitial(method: LoadMethod, slotId: String, width: Double, height: Double)
    case fullScreen(method: LoadMethod, slotId: String)
}

extension DefaultADs: ADCompatble {
    public var taskFactoryCategory: TaskFactoryCategory {
        return .default
    }
    
    public var method: LoadMethod {
        switch self {
        case let .splash(method, _, _, _, _), let .feed(method, _, _, _), let .fullScreen(method, _), let .interstitial(method, _, _, _), let .rewardVideo(method, _, _, _, _, _):
            return method
        }
    }
    
    public var category: ADCategory {
        switch self {
        case .splash:
            return .splash
        case .rewardVideo:
            return .rewardVideo
        case .feed:
            return .feed
        case .interstitial:
            return .interstitial
        case .fullScreen:
            return .fullScreen
        }
    }
}

public enum ExpressADs {
    case splash(method: LoadMethod, slotId: String, width: Double, height: Double, tolerateTimeout: Double?, hideSkipButton: Bool?)
    case rewardVideo(method: LoadMethod, slotId: String, userId: String, rewardName: String?, rewardAmount: Int?, extra: String?)
    case feed(method: LoadMethod, slotId: String, imageSize: Int, count: Int = 1, width: Double, height: Double)
    case interstitial(method: LoadMethod, slotId: String, width: Double, height: Double)
    case fullScreen(method: LoadMethod, slotId: String)
}

extension ExpressADs: ADCompatble {
    public var taskFactoryCategory: TaskFactoryCategory {
        return .default
    }
    
    public var method: LoadMethod {
        switch self {
        case let .splash(method, _, _, _, _, _), let .feed(method, _, _, _, _, _), let .fullScreen(method, _), let .interstitial(method, _, _, _), let .rewardVideo(method, _, _, _, _, _):
            return method
        }
    }
    
    public var category: ADCategory {
        switch self {
        case .splash:
            return .splash
        case .rewardVideo:
            return .rewardVideo
        case .feed:
            return .feed
        case .interstitial:
            return .interstitial
        case .fullScreen:
            return .fullScreen
        }
    }
}
