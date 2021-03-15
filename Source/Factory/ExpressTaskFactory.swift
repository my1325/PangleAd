//
//  ExpressTaskFactory.swift
//  pangle_flutter
//
//  Created by my on 2021/3/12.
//

import Foundation
import ADManager

public final class ExpressTaskFactory: TaskFactory {
    public override func prepareFor(_ ad: ADCompatble) -> TaskCompatible {
        guard let _ad = ad as? ExpressADs  else { return NoneTask() }
        switch _ad {
        case let .rewardVideo(_, slotId, userId, rewardName, rewardAmount, extra):
            return ExpressRewardVideoADTask(slotId, userId: userId, rewardName: rewardName, rewardAmount: rewardAmount, extra: extra, ad: _ad)
        case let .feed(_, slotId, imageSize, count, width, height):
            return ExpressNativeADTask(slotId, count: count, imageSize: imageSize.rawValue, width: width, height: height, ad: _ad)
        case let .interstitial(_, slotId, width, height):
            return IntersitialADTask(slotId, width: width, height: height, ad: _ad)
        case let .fullScreen(_, slotId):
            return ExpressFullScreenAdTask(slotId, ad: _ad)
        case let .banner(_, slotId, interval, width, height, vc):
            return ExpressBannerTask(slotId, interval: interval, width: width, height: height, vc: vc, ad: _ad)
        }
    }
}
