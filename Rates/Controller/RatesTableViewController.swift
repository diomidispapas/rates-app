//
//  RatesTableViewController.swift
//  Rates
//
//  Created by Diomidis Papas on 13/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import UIKit

final class RatesTableViewController: UITableViewController {
    
    private let viewModel: RatesTableViewModel
    
    private var firstTableViewCell: UITableViewCell? {
        let indexPath = IndexPath(row: 0, section: 0)
        return tableView.cellForRow(at: indexPath)
    }
    
    // MARK: Initialization
    
    init(viewModel: RatesTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupTableView()
        setupDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    private func setupTableView() {
        tableView.register(RateTableViewCell.self)
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = .clear
    }
    
    private func setupDefaults() {
        viewModel.delegate = self
        navigationItem.title = viewModel.title
    }
}

//MARK: UITableViewControllerDataSource
extension RatesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RateTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let dataSource = viewModel.dataSource(for: indexPath)
        let delegate = viewModel.delegate(for: indexPath)
        cell.configure(with: dataSource, delegate: delegate)
        cell.textFieldChangeClosure = { [weak viewModel] text in
            viewModel?.update(with: text, at: indexPath)
        }
        return cell
    }
}

//MARK: UITableViewControllerDelegate
extension RatesTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationIndexPath = IndexPath(row: 0, section: 0)
        tableView.beginUpdates()
        viewModel.moveRate(from: indexPath.row, to: destinationIndexPath.row)
        self.tableView.moveRow(at: indexPath, to: destinationIndexPath)
        tableView.endUpdates()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            tableView.reloadData()

            UIView.animate(withDuration: 0.5, animations: {
                tableView.scrollToRow(at: destinationIndexPath, at: .top, animated: false)
            }, completion: { (finished) in
                self.firstTableViewCell?.becomeFirstResponder()
            })
        }
    }
}

extension RatesTableViewController: RatesTableViewModelDelegate {
    
    func ratesTableViewModel(_: RatesTableViewModel, didRequestUpdateWith diff: RatesTableViewDiff) {
        UIView.performWithoutAnimation({
            tableView.reloadRows(at: diff, with: .none)
        })
        firstTableViewCell?.becomeFirstResponder()
    }
}
