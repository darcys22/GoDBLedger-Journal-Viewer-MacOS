//  Created by Oleg Hnidets on 4/2/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

import Cocoa
import OHMySQL

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	
    private var transactions = [Transaction]()
    private var accounts = [Account]()
    
	@IBOutlet private weak var tableView: NSTableView!
    @IBOutlet weak var tbtableView: NSTableView!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureMySQL()
		
        TransactionsProvider().loadTransactions { transactions in
            self.transactions = transactions
            print(transactions.count)
            self.tableView.reloadData()
        }
        
        AccountsProvider().loadAccounts { accounts in
            self.accounts = accounts
            print(accounts.count)
            self.tableView.reloadData()
        }
	}
	
	private func configureMySQL() {
        let user = OHMySQLUser(userName: "godbledger", password: "password", serverName: "192.168.1.98", dbName: "ledger", port: 3306, socket: "")
		let coordinator = OHMySQLStoreCoordinator(user: user!)
		coordinator.encoding = .UTF8MB4
		coordinator.connect()
		
		let context = OHMySQLQueryContext()
		context.storeCoordinator = coordinator
		OHMySQLContainer.shared.mainQueryContext = context
	}
	
	// MARK: - NSTableViewDataSource -
	
	func numberOfRows(in rtableView: NSTableView) -> Int {
        if (rtableView == tableView)
        {
            return transactions.count
        }
        else if (rtableView == tbtableView)
        {
            return accounts.count
        }
		
        return 0
	}
	
	func tableView(_ rtableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {


        if (rtableView == tableView)
        {
            let task = transactions[row]
            if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "dateColumn") {
                let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "dateCellIdentifier"), owner: nil) as? NSTableCellView
                cell?.textField?.stringValue = task.Date ?? ""

                return cell
            } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "idColumn") {
                let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "idCellIdentifier"), owner: nil) as? NSTableCellView
                cell?.textField?.stringValue = task.ID ?? ""
                return cell
            } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "descriptionColumn") {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "descriptionCellIdentifier"), owner: nil) as? NSTableCellView
            cell?.textField?.stringValue = task.Description ?? ""
            return cell
            } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "accountColumn") {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "accountCellIdentifier"), owner: nil) as? NSTableCellView
            cell?.textField?.stringValue = task.Account ?? ""
            return cell
            } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "currencyColumn") {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "currencyCellIdentifier"), owner: nil) as? NSTableCellView
            cell?.textField?.stringValue = task.Currency ?? ""
            return cell
            } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "amountColumn") {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "amountCellIdentifier"), owner: nil) as? NSTableCellView
            cell?.textField?.stringValue = (task.Amount ?? 0).stringValue
            return cell
            }
        }
        else if (rtableView == tbtableView)
        {
            let account = accounts[row]
            if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "accountColumn") {
                let cell = tbtableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "accountCellIdentifier"), owner: nil) as? NSTableCellView
                cell?.textField?.stringValue = account.Account ?? ""

                return cell
            } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "amountColumn") {
                let cell = tbtableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "amountCellIdentifier"), owner: nil) as? NSTableCellView
                cell?.textField?.stringValue = (account.Amount ?? 0).stringValue

                return cell
            }
        }

		
		return nil
	}
}

