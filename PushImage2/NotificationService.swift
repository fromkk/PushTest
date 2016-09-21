//
//  NotificationService.swift
//  PushImage2
//
//  Created by Ueoka Kazuya on 2016/09/18.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            if let imageURLString: String = bestAttemptContent.userInfo["image-url"] as? String,
                let imageURL: URL = URL(string: imageURLString) {
                let path: String = NSTemporaryDirectory().appending("tmp.jpg")
                
                let localPath: URL = URL(fileURLWithPath: path)
                let task: URLSessionTask = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                    
                    guard let data = data else {
                        bestAttemptContent.title = "attachment create failed \(#line)"
                        contentHandler(bestAttemptContent)
                        return
                    }
                    
                    do {
                        try data.write(to: localPath, options: [NSData.WritingOptions.atomicWrite])
                    } catch {
                        bestAttemptContent.title = "image save failed \(#line)"
                        contentHandler(bestAttemptContent)
                        return
                    }
                    
                    do {
                        let attachment: UNNotificationAttachment = try UNNotificationAttachment(identifier: "image", url: localPath, options: nil)
                        bestAttemptContent.attachments = [attachment]
                        contentHandler(bestAttemptContent)
                        return
                    } catch {
                        bestAttemptContent.title = "attachment create failed \(#line)"
                        contentHandler(bestAttemptContent)
                        return
                    }
                })
                task.resume()
            } else {
                bestAttemptContent.title = "attachment create failed \(#line)"
                contentHandler(bestAttemptContent)
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
