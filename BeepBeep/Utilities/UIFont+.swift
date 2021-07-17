//
//  UIFont+.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/07/17.
//

import UIKit

extension UIFont {
    private enum Pretendard: String {
        case black = "Pretendard-Black"
        case bold = "Pretendard-Bold"
        case extraBold = "Pretendard-ExtraBold"
        case extraLight = "Pretendard-ExtraLight"
        case light = "Pretendard-Light"
        case medium = "Pretendard-Medium"
        case regular = "Pretendard-Regular"
        case semiBold = "Pretendard-SemiBold"
        case thin = "Pretendard-Thin"
    }

    private static func scaledFont(with type: Pretendard, textStyle: UIFont.TextStyle) -> UIFont {
        let fontDescriptor: UIFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)

        guard let font = UIFont(name: type.rawValue, size: fontDescriptor.pointSize) else {
            fatalError("""
                Failed to load the \(type.rawValue) font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """)
        }

        return UIFontMetrics.default.scaledFont(for: font)
    }

    /// The font for body text with Pretendard.
    static let pretendardBody: UIFont = scaledFont(with: .regular, textStyle: .body)

    /// The font for callouts with Pretendard.
    static let pretendardCallOut: UIFont = scaledFont(with: .regular, textStyle: .callout)

    /// The font for standard captions with Pretendard.
    static let pretendardCaption1: UIFont = scaledFont(with: .regular, textStyle: .caption1)

    /// The font for alternate captions with Pretendard
    static let pretendardCaption2: UIFont = scaledFont(with: .regular, textStyle: .caption2)

    /// The font fot footnotes with Pretendard
    static let pretendardFootnote: UIFont = scaledFont(with: .regular, textStyle: .footnote)

    /// The font for headings with Pretendard
    static let pretendardHeadline: UIFont = scaledFont(with: .semiBold, textStyle: .headline)

    /// The font for subheadings with Pretendard
    static let pretendardSubheadline: UIFont = scaledFont(with: .regular, textStyle: .subheadline)

    /// The font style for large titles with Pretendard.
    static let pretendardLargeTitle: UIFont = scaledFont(with: .regular, textStyle: .largeTitle)

    /// The font for first-level hierarchical headings with Pretendard.
    static let pretendardTitle1: UIFont = scaledFont(with: .regular, textStyle: .title1)

    /// The font for second-level hierarchical headings with Pretendard.
    static let pretendardTitle2: UIFont = scaledFont(with: .regular, textStyle: .title2)

    /// The font for thrid-level hierarchical headlings with Pretendard.
    static let pretendardTitle3: UIFont = scaledFont(with: .regular, textStyle: .title3)
}
