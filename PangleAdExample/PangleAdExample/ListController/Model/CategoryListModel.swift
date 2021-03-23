//
//  CategoryListModel.swift
//  PangleAd
//
//  Created by my on 2021/3/15.
//

import Foundation
import ADManager
import PangleAd
import RxDataSources

enum ADCategory: SectionModelType {
    typealias Item = ADList
    
    case `default`(adList: [ADList])
    case express(adList: [ADList])
    
    init(original: ADCategory, items: [ADList]) {
        switch original {
        case .default:
            self = .default(adList: items)
        case .express:
            self = .express(adList: items)
        }
    }
    
    var name: String {
        switch self {
        case .default:
            return "Default"
        case .express:
            return "Express"
        }
    }
    
    var items: [ADList] {
        switch self {
        case let .default(adList), let .express(adList):
            return adList
        }
    }
    
    static let defaultModelList: [ADCategory] = [
        .default(adList: [.splash, .videoReward, .feed]),
        .express(adList: [.fullscreen, .videoReward, .feed, .intersitial, .banner])
    ]
}

enum ADList: String {
    case splash
    case fullscreen
    case videoReward
    case feed
    case intersitial
    case banner
}
