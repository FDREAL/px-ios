//
//  NextStepHelper.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 2/3/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

extension MercadoPagoCheckoutViewModel {
    
    func hasError() -> Bool{
        return error != nil
    }
    
    func needSearch() -> Bool {
        return search == nil
    }
    func arePaymentTypeSelected() -> Bool {
        guard let selectedType = self.paymentOptionSelected else {
            return false
        }
        return !selectedType.hasChildren()
    }
    func needCompleteCard() -> Bool {
        guard let selectedType = self.paymentOptionSelected else {
            return false
        }
        if !selectedType.isCard() {
            return false
        }
        return self.cardToken == nil && !selectedType.isCustomerPaymentMethod()
    }
    
    func showConfirm() -> Bool {
        return self.paymentData.complete()
    }
    
    func showCongrats() -> Bool {
        return self.payment != nil
    }
    func needGetIdentification() -> Bool {
        guard let pm = self.paymentData.paymentMethod , let option = self.paymentOptionSelected else {
            return false
        }
        guard let holder = self.cardToken?.cardholder else {
            return false
        }
        if holder.identification == nil && pm.isIdentificationRequired() && !option.isCustomerPaymentMethod(){
            return true
        }else{
            return false
        }
    }
    func needGetIssuer() -> Bool {
        guard let pm = self.paymentData.paymentMethod else {
            return false
        }
        if paymentData.issuer == nil /* && pm.isIssuerRequired() */  { //TODO
            return true
        }
        return false
    }
    func needChosePayerCost() -> Bool {
        guard let pm = self.paymentData.paymentMethod else {
            return false
        }
        if pm.isCreditCard() && self.paymentData.payerCost == nil {
            return true
        }else{
            return false
        }
    }
    func needSecurityCode() -> Bool {
        guard let pmSelected = self.paymentOptionSelected else {
            return false
        }
        if pmSelected.isCustomerPaymentMethod() && self.paymentData.token == nil {
            return true
        }
        return false
    }

    
}
