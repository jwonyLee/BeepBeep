//
//  UIView+.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/07/12.
//

import UIKit

extension UIView {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}
