//
//  InstructionsSubtitleRenderer.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsSubtitleRenderer: NSObject {
    let XXL_MARGIN: CGFloat = 50.0
    let XL_MARGIN: CGFloat = 42.0
    let L_MARGIN: CGFloat = 24.0
    let S_MARGIN: CGFloat = 16.0
    let CONTENT_WIDTH_PERCENT: CGFloat = 84.0
    let LABEL_FONT_SIZE: CGFloat = 22.0

    func render(instructionsSubtitle: InstructionsSubtitleComponent) -> UIView {
        let instructionsSubtitleView = SubtitleView()
        instructionsSubtitleView.translatesAutoresizingMaskIntoConstraints = false
        instructionsSubtitleView.backgroundColor = .pxWhite
        let attributes = [ NSFontAttributeName: Utils.getFont(size: LABEL_FONT_SIZE) ]
        let attributedString = NSAttributedString(string: instructionsSubtitle.props.subtitle, attributes: attributes)
        instructionsSubtitleView.subtitleLabel = buildSubtitleLabel(with: attributedString, in: instructionsSubtitleView)
        return instructionsSubtitleView
    }

    func buildSubtitleLabel(with text: NSAttributedString, in superView: UIView) -> UILabel {
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .pxBrownishGray
        subtitleLabel.numberOfLines = 0
        subtitleLabel.attributedText = text
        subtitleLabel.lineBreakMode = .byWordWrapping
        superView.addSubview(subtitleLabel)

        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width * CONTENT_WIDTH_PERCENT / 100

        let height = UILabel.requiredHeight(forAttributedText: text, withFont: Utils.getFont(size: LABEL_FONT_SIZE), inWidth: screenWidth)
        MPLayout.setHeight(owner: subtitleLabel, height: height).isActive = true
        MPLayout.setWidth(ofView: subtitleLabel, asWidthOfView: superView, percent: CONTENT_WIDTH_PERCENT).isActive = true
        MPLayout.centerHorizontally(view: subtitleLabel, to: superView).isActive = true
        MPLayout.pinBottom(view: subtitleLabel, to: superView, withMargin: L_MARGIN).isActive = true
        MPLayout.pinTop(view: subtitleLabel, to: superView, withMargin: L_MARGIN).isActive = true
        return subtitleLabel
    }
}

class SubtitleView: UIView {
    public var subtitleLabel: UILabel?
}