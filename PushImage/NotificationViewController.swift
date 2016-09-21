//
//  NotificationViewController.swift
//  PushImage
//
//  Created by Ueoka Kazuya on 2016/09/18.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#file, #function)
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        
        if let attachment: UNNotificationAttachment = notification.request.content.attachments.first {
            _ = attachment.url.startAccessingSecurityScopedResource()
            do {
                let data: Data = try Data(contentsOf: attachment.url)
                self.imageView.image = UIImage(data: data)
            } catch {
                print("failed get image")
            }
            attachment.url.stopAccessingSecurityScopedResource()
        }
    }
}
