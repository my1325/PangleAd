//
//  DefaultTaskFactory.swift
//  pangle_flutter
//
//  Created by my on 2021/3/11.
//

import Foundation
import ADManager

public final class DefaultTaskFactory: TaskFactory {
    public override func prepareFor(_ ad: ADCompatble) -> TaskCompatible {
        guard let _ad = ad as? DefaultADs else { return NoneTask() }
        switch _ad {
        case let .splash(_, slotId, frame, tolerateTimeout, hideSkipButton):
            return SplashADTask(slotId, frame: frame, tolerateTimeout: tolerateTimeout, hideSkipButton: hideSkipButton, ad: _ad)
        case let .rewardVideo(_, slotId, userId, rewardName, rewardAmount, extra):
            return RewardVideoADTask(slotId, userId: userId, rewardName: rewardName, rewardAmount: rewardAmount, extra: extra, ad: _ad)
        case let .feed(_, slotId, imageSize, count):
            return NativeADTask(slotId, imageSize: imageSize, count: count, ad: _ad)
        case .interstitial(_, _, _, _):
            return NoneTask()
        case let .fullScreen(_, slotId):
            return FullScreenAdTask(slotId: slotId, ad: _ad)
        }
    }
}
