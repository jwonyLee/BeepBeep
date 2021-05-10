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

    // MARK: - Properties
    static let identifier: String = "CollectionsCell"

    // MARK: - View Properties
    private var emojiLabel = UILabel().then {
        $0.adjustsFontForContentSizeCategory = true
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        $0.text = "🌩"
        $0.textColor = .black
    }

    private var nameLabel = UILabel().then {
        $0.adjustsFontForContentSizeCategory = true
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
        $0.text = "Lorem IpsumLorem IpsumLorem IpsumLorem IpsumLorem Ipsum"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.textColor = .black
    }

    private var countLabel = UILabel().then {
        $0.adjustsFontForContentSizeCategory = true
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
        $0.text = "17"
        $0.textColor = .black
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
}

// MARK: - Private
private extension CollectionsCell {
    func configureViews() {
        contentView.addSubview(emojiLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(countLabel)
    }

    func setViewsConstraints() {
        emojiLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        emojiLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.leading.equalTo(contentView.snp.leading).offset(8)
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
