//
//  Size.swift
//  ValetParking
//
//  Created by macbook on 23/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

func ip5(_ value: CGFloat) -> CGFloat {
    return value / 640 * UIScreen.main.bounds.width
}

func ip6(_ value: CGFloat) -> CGFloat {
    return value / 750 * UIScreen.main.bounds.width
}

func ip6plus(_ value: CGFloat) -> CGFloat {
    return value / 1080 * UIScreen.main.bounds.width
}

func ip5Point(_ value: CGFloat) -> CGFloat {
    return value / 320 * UIScreen.main.bounds.width
}

func ip6Point(_ value: CGFloat) -> CGFloat {
    return value / 375 * UIScreen.main.bounds.width
}

func ip6plusPoint(_ value: CGFloat) -> CGFloat {
    return value / 414 * UIScreen.main.bounds.width
}

func iPad9(_ value: CGFloat) -> CGFloat {
    return value / 1536 * UIScreen.main.bounds.width
}
