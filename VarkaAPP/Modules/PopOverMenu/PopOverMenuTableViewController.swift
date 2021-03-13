//
//  PopOverMenuTableTableViewController.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 09.03.2021.
//

import UIKit

final class PopOverMenuTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var delegate: AddNewProductViewControllerDelegate!
    var viewModel: PopOverMenuTableViewModelProtocol!
    
    // MARK: - Lifecycle method
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Override methods
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: PopOverTableSize.width.rawValue ,
                                      height: PopOverTableSize.height.rawValue)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CellFromPopOverTableViewCell
        cell.titleProduct.text = viewModel.selectedCategory(at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.getSelectedItemFromPopOver(item: viewModel.selectedCategory(at: indexPath))
        dismiss(animated: true, completion: nil)
    }
}
