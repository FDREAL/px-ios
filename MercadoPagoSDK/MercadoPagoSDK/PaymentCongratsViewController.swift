//
//  PaymentCongratsViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 9/5/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class PaymentCongratsViewController: MercadoPagoUIViewController , UITableViewDelegate, UITableViewDataSource {

    let congratsLayout =
        ["approved" : ["header" : "approvedPaymentHeader", "headerHeight" : ApprovedPaymentBodyTableViewCell.ROW_HEIGHT, "body" : "approvedPaymentBody", "bodyHeight" : ApprovedPaymentBodyTableViewCell.ROW_HEIGHT],
        "rejected" : ["header" : "rejectedPaymentHeader", "headerHeight" : RejectedPaymentHeaderTableViewCell.ROW_HEIGHT, "body" : "rejectedPaymentBody", "bodyHeight" : RejectedPaymentBodyTableViewCell.ROW_HEIGHT],
        "authorize" : ["header" : "authorizePaymentHeader", "headerHeight" : AuthorizePaymentHeaderTableViewCell.ROW_HEIGHT, "body" : "authorizePaymentBody", "bodyHeight" : AuthorizePaymentBodyTableViewCell.ROW_HEIGHT],
        "pending" : ["header" : "pendingPaymentHeader", "headerHeight" : PendingPaymentHeaderTableViewCell.ROW_HEIGHT, "body" : "", "bodyHeight" : 0]
        ]
    
    var bundle = MercadoPago.getBundle()
    var payment : Payment!
    var layoutTemplate : String!
    
    @IBOutlet weak var congratsContentTable: UITableView!

    init(payment: Payment, cancelCallback : (Void -> Void)?){
        super.init(nibName: "PaymentCongratsViewController", bundle : bundle)
        self.payment = payment
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.layoutTemplate = getLayoutName(self.payment)
        self.congratsContentTable.delegate = self
        self.congratsContentTable.dataSource = self
        
        self.congratsContentTable.tableHeaderView = UIView(frame: CGRectMake(0.0, 0.0,
            self.congratsContentTable.bounds.size.width, 0.01))
        self.congratsContentTable.rowHeight = UITableViewAutomaticDimension
        self.congratsContentTable.estimatedRowHeight = 160.0
        if self.callbackCancel == nil {
            self.callbackCancel = {
                if self.navigationController != nil {
                    self.navigationController!.popViewControllerAnimated(true)
                } else {
                    self.dismissViewControllerAnimated(true, completion: {
                        
                    })
                }
            }
        }
        
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (self.navigationItem.rightBarButtonItem != nil) {
           self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let header = congratsLayout[self.layoutTemplate]!["header"] as! String
            let headerCell =  self.congratsContentTable.dequeueReusableCellWithIdentifier(header) as! CongratsFillmentDelegate
            return headerCell.fillCell(self.payment, callbackCancel: nil)
        } else if indexPath.section == 1 {
            let body = congratsLayout[self.layoutTemplate]!["body"] as? String
            if body != nil && body?.characters.count > 0 {
                let bodyCell = self.congratsContentTable.dequeueReusableCellWithIdentifier(body!) as! CongratsFillmentDelegate
                return bodyCell.fillCell(self.payment, callbackCancel: self.callbackCancel)
            }
            return UITableViewCell()
        }
        
        // Exit button with callbackCancel action
        let exitButtonCell = self.congratsContentTable.dequeueReusableCellWithIdentifier("exitButtonCell") as! ExitButtonTableViewCell
        exitButtonCell.callbackCancel = self.callbackCancel
        return exitButtonCell
        
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0 :
            return (self.congratsLayout[self.layoutTemplate]!["headerHeight"] as! CGFloat)
        default:
            return (self.congratsLayout[self.layoutTemplate]!["bodyHeight"] as! CGFloat)
        }
    }

    
    private func registerCells(){
        let approvedPaymentHeader = UINib(nibName: "ApprovedPaymentHeaderTableViewCell", bundle: self.bundle)
        self.congratsContentTable.registerNib(approvedPaymentHeader, forCellReuseIdentifier: "approvedPaymentHeader")
        let approvedPaymentBody = UINib(nibName: "ApprovedPaymentBodyTableViewCell", bundle: self.bundle)
        self.congratsContentTable.registerNib(approvedPaymentBody, forCellReuseIdentifier: "approvedPaymentBody")
        
        let rejectedPaymentHeader = UINib(nibName: "RejectedPaymentHeaderTableViewCell", bundle: self.bundle)
        self.congratsContentTable.registerNib(rejectedPaymentHeader, forCellReuseIdentifier: "rejectedPaymentHeader")
        let rejectedPaymentBody = UINib(nibName: "RejectedPaymentBodyTableViewCell", bundle: self.bundle)
        self.congratsContentTable.registerNib(rejectedPaymentBody, forCellReuseIdentifier: "rejectedPaymentBody")
        
        
        let authorizePaymentHeader = UINib(nibName: "AuthorizePaymentHeaderTableViewCell", bundle: self.bundle)
        self.congratsContentTable.registerNib(authorizePaymentHeader, forCellReuseIdentifier: "authorizePaymentHeader")
        let authorizePaymentBody = UINib(nibName: "AuthorizePaymentBodyTableViewCell", bundle: self.bundle)
        self.congratsContentTable.registerNib(authorizePaymentBody, forCellReuseIdentifier: "authorizePaymentBody")
        
        let pendingPaymentHeader = UINib(nibName: "PendingPaymentHeaderTableViewCell", bundle: self.bundle)
        self.congratsContentTable.registerNib(pendingPaymentHeader, forCellReuseIdentifier: "pendingPaymentHeader")
        
        let exitButtonCell = UINib(nibName: "ExitButtonTableViewCell", bundle: self.bundle)
        
        self.congratsContentTable.registerNib(exitButtonCell, forCellReuseIdentifier: "exitButtonCell")
        
    }
    
    private func getLayoutName(payment : Payment) -> String {
    
        if payment.status == PaymentStatus.REJECTED.rawValue {
            if payment.statusDetail != nil && payment.statusDetail == "cc_rejected_call_for_authorize" {
                return "authorize"
            }
        }
        
        return payment.status
    }

    override public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

}

enum PaymentStatus : String {
    case APPROVED = "approved"
    case REJECTED = "rejected"
    case PENDING = "pending"
}