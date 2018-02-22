//
//  CenterViewControllerDelegate.swift
//  SlideDemo(抽屉左滑右滑)
//
//  Created by ljb48229 on 2018/2/22.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

@objc
protocol CenterViewControllerDelegate {
    @objc optional func toggleLeftPannel()
    @objc optional func toggleRightPanel()
    @objc optional func collapseSidePanels()
}
