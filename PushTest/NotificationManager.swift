//
//  NotificationManager.swift
//  PushTest
//
//  Created by Ueoka Kazuya on 2016/09/18.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import Foundation
import UserNotifications
import UserNotificationsUI

struct NotificationManager {
    static let shared: NotificationManager = NotificationManager()
    
    private init() {}
    
    static func setup() {
        self.shared.setupCategory()
    }
    
    private func setupCategory() {
        let category = UNNotificationCategory(identifier: "category", actions: [], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}
