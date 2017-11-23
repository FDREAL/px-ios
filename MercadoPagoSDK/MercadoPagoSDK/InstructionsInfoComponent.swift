//
//  InstructionsInfoComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/16/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class InstructionsInfoComponent: NSObject {
    var props: InstructionsInfoProps
    
    init(props: InstructionsInfoProps) {
        self.props = props
    }
}
class InstructionsInfoProps: NSObject {
    var infoTitle: String?
    var infoContent: [String]?
    var bottomDivider: Bool?
    init(infoTitle: String, infoContent: [String], bottomDivider: Bool) {
        self.infoTitle = infoTitle
        self.infoContent = infoContent
        self.bottomDivider = bottomDivider
    }
}