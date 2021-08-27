//
//  CollectionsCell.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/05/10.
//

import UIKit
import SnapKit
import Then

class CollectionsCell: UICollectionViewCell {
    // MARK: - View Properties
    private var emojiLabel: UILabel = UILabel().then {
        $0.adjustsFontForContentSizeCategory = true
        $0.font = UIFont.pretendardLargeTitle
        $0.textColor = .label
    }

    private var nameLabel: UILabel = UILabel().then {
        $0.adjustsFontForContentSizeCategory = true
        $0.font = UIFont.pretendardHeadline
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.textColor = .label
    }

    private var countLabel: UILabel = UILabel().then {
        $0.adjustsFontForContentSizeCategory = true
        $0.font = UIFont.pretendardSubheadline
        $0.text = "17"
        $0.textColor = .label
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = UIColor(named: "BeepGray")
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true

        configureViews()
        setViewsConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not beem implemented")
    }

    func configure(_ category: Category) {
        self.emojiLabel.text = category.emoji
        self.nameLabel.text = category.name
        self.countLabel.text = "\(category.items.count)"
    }
}

// MARK: - Private
extension CollectionsCell {
    private func configureViews() {
        contentView.addSubview(emojiLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(countLabel)
    }

    private func setViewsConstraints() {
        emojiLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        emojiLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.leading.equalTo(contentView.snp.leading).offset(16)
        }

        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(emojiLabel.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualTo(countLabel.snp.leading).offset(-8)
            $0.centerY.equalTo(contentView.snp.centerY)
        }

        countLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        countLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
    }
}
