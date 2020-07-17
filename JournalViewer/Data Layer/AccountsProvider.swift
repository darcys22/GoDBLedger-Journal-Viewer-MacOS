//  Created by Oleg Hnidets on 4/2/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

import Foundation
import OHMySQL

class AccountsProvider {
	
	func loadAccounts(_ completion: @escaping ([Account]) -> ()) {
        let queryString  = """
            SELECT split_accounts.account_id as Account,
                         Sum(splits.amount) as Amount
            FROM   splits
                         JOIN split_accounts
                             ON splits.split_id = split_accounts.split_id
            WHERE  splits.split_date <= CURDATE()
                         AND "void" NOT IN (SELECT t.tag_name
            FROM   tags AS t
            JOIN transaction_tag AS tt
                ON tt.tag_id = t.tag_id
            WHERE  tt.transaction_id = splits.transaction_id)
            GROUP  BY split_accounts.account_id
            ;
        """
        let query = OHMySQLQueryRequest.init(queryString: queryString)
		let response = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)
		
		guard let responseObject = response as? [[String : Any]] else {
			completion([])
			return
		}
		
        var accounts = [Account]()
        for accountResponse in responseObject {
            let account = Account()
            account.map(fromResponse: accountResponse)
            accounts.append(account)
        }
        
        completion(accounts)
    }
}
