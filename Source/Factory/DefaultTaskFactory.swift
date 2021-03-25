//
//  DefaultTaskFactory.swift
//  pangle_flutter
//
//  Created by my on 2021/3/11.
//

import Foundation
import GeADManager

public final class DefaultTaskFactory: TaskFactory {
    public override func prepareFor(_ ad: ADCompatble) -> TaskCompatible {
        guard let _ad = ad as? DefaultADs else { return NoneTask() }
        switch _ad {
        case let .splash(slotId, frame, tolerateTimeout, hideSkipButton):
            return SplashADTask(slotId, frame: frame, tolerateTimeout: tolerateTimeout, hideSkipButton: hideSkipButton, ad: _ad)
        case let .rewardVideo(slotId, userId, rewardName, rewardAmount, extra):
            return RewardVideoADTask(slotId, userId: userId, rewardName: rewardName, rewardAmount: rewardAmount, extra: extra, ad: _ad)
        case let .feed(slotId, imageSize, count):
            return NativeADTask(slotId, imageSize: imageSize.rawValue, count: count, ad: _ad)
        }
    }
}
