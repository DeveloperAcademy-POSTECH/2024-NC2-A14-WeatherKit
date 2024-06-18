//
//  OffsetKey.swift
//  WeatherPlan
//
//  Created by Yunki on 6/18/24.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: Value = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
