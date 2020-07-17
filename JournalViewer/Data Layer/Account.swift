//  Created by Oleg Hnidets on 4/2/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

import Foundation
import OHMySQL

class Account: NSObject, OHMappingProtocol {
    
    @objc var Account: String?
    @objc var Amount: NSNumber?
    
    func mappingDictionary() -> [AnyHashable : Any]! {
        return ["Account": "Account",
                "Amount": "Amount"]
    }

    func mySQLTable() -> String! {
        return "transactions"
    }
    
    func primaryKey() -> String! {
        return "transaction_id"
    }
}
