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
        case let .splash(_, slotId, width, height, tolerateTimeout, hideSkipButton):
            return ExpressSplashADTask(slotId, width: width, height: height, tolerateTimeout: tolerateTimeout, hideSkipButton: hideSkipButton, ad: _ad)
        case let .rewardVideo(_, slotId, userId, rewardName, rewardAmount, extra):
            return ExpressRewardVideoADTask(slotId, userId: userId, rewardName: rewardName, rewardAmount: rewardAmount, extra: extra, ad: _ad)
        case let .feed(_, slotId, imageSize, count, width, height):
            return ExpressNativeADTask(slotId, count: count, imageSize: imageSize, width: width, height: height, ad: _ad)
        case let .interstitial(_, slotId, width, height):
            return IntersitialADTask(slotId, width: width, height: height, ad: _ad)
        case let .fullScreen(_, slotId):
            return ExpressFullScreenAdTask(slotId, ad: _ad)
        }
    }
}
