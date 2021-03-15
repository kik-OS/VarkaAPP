//
//  PopOverMenuTableTableViewController.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 09.03.2021.
//

import UIKit

class PopOverMenuTableViewController: UITableViewController {

    // MARK: - Properties
    
    var delegate: AddNewProductViewControllerDelegate!
    var viewModel: PopOverMenuTableViewModelProtocol!
    
    // MARK: - Lifecycle method
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Override methods
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: popOverTableSize.width.rawValue ,
                                      height: popOverTableSize.height.rawValue)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        delegate.getSelectedItemFromPopOver(selectedCategory: viewModel.selectedCategory(at: indexPath))
        dismiss(animated: true, completion: nil)
    }
}
