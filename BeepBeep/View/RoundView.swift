//
//  RoundView.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/05/09.
//

import UIKit

class RoundView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 15
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
