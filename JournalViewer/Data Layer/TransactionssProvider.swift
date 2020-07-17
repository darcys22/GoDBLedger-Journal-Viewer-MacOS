//  Created by Oleg Hnidets on 4/2/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

import Foundation
import OHMySQL

class TransactionsProvider {
	
	func loadTransactions(_ completion: @escaping ([Transaction]) -> ()) {
//        let queryString = "SELECT * FROM transactions;"
        let queryString  = """
            SELECT
                transactions.transaction_id,
                splits.split_date,
                splits.description,
                splits.currency,
                splits.amount,
                split_accounts.account_id
            FROM splits
                JOIN split_accounts
                    ON splits.split_id = split_accounts.split_id
                JOIN transactions
                    on splits.transaction_id = transactions.transaction_id
            ;
        """
        let query = OHMySQLQueryRequest.init(queryString: queryString)

        let response = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)
		
		guard let responseObject = response as? [[String : Any]] else {
			completion([])
			return
		}
		
        var transactions = [Transaction]()
        for transactionResponse in responseObject {
            let transaction = Transaction()
            transaction.map(fromResponse: transactionResponse)
            transactions.append(transaction)
        }
        
        completion(transactions)
			}
}
