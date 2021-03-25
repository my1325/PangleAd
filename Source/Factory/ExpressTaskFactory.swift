//
//  ExpressTaskFactory.swift
//  pangle_flutter
//
//  Created by my on 2021/3/12.
//

import Foundation
import GeADManager

public final class ExpressTaskFactory: TaskFactory {
    public override func prepareFor(_ ad: ADCompatble) -> TaskCompatible {
        guard let _ad = ad as? ExpressADs  else { return NoneTask() }
        switch _ad {
        case let .rewardVideo(slotId, userId, rewardName, rewardAmount, extra):
            return ExpressRewardVideoADTask(slotId, userId: userId, rewardName: rewardName, rewardAmount: rewardAmount, extra: extra, ad: _ad)
        case let .feed(slotId, imageSize, count, width, height):
            return ExpressNativeADTask(slotId, count: count, imageSize: imageSize.rawValue, width: width, height: height, ad: _ad)
        case let .interstitial(slotId, width, height):
            return IntersitialADTask(slotId, width: width, height: height, ad: _ad)
        case let .fullScreen(slotId):
            return ExpressFullScreenAdTask(slotId, ad: _ad)
        case let .banner(slotId, interval, width, height, vc):
            return ExpressBannerTask(slotId, interval: interval, width: width, height: height, vc: vc, ad: _ad)
        }
    }
}
