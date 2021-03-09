//
//  PopOverMenuTableTableViewController.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 09.03.2021.
//

import UIKit

class PopOverMenuTableTableViewController: UITableViewController {

    let array = ["Макароны", "Рис", "Гречка", "Крупа", "Пельмени", "Вареники"]
    
    var delegate: AddNewProductViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 150 , height: 165)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CellFromPopOverTableViewTableViewCell
        cell.titleProduct.text = array[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.getSelectedItemFromPopOver(item: array[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}
