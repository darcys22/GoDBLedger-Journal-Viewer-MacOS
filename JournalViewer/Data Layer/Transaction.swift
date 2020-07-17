//  Created by Oleg Hnidets on 4/2/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

import Foundation
import OHMySQL

class Transaction: NSObject, OHMappingProtocol {
    
    @objc var Account: String?
    @objc var ID: String?
    @objc var Date: String?
    @objc var Description: String?
    @objc var Amount: NSNumber?
    @objc var Currency: String?

    
    func mappingDictionary() -> [AnyHashable : Any]! {

        return ["ID" : "transaction_id",
                "Date" : "split_date",
                "Description" :"description",
                "Currency" : "currency",
                "Amount" : "amount",
                "Account" : "account_id"]
    }

    func mySQLTable() -> String! {
        return "transactions"
    }
    
    func primaryKey() -> String! {
        return "transaction_id"
    }
}
