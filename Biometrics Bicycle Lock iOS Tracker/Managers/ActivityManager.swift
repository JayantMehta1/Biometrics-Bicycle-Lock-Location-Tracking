//
//  ActivityManager.swift
//  Biometrics Bicycle Lock iOS Tracker
//
//  Created by Jayant Mehta on 2021-07-25.
//

import Foundation
import CoreMotion

class ActivityManager: NSObject, ObservableObject {
    private let activityManager = CMMotionActivityManager()
    private let pedoMeter = CMPedometer()
}
