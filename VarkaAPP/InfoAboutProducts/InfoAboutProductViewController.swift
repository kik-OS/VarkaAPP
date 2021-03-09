//
//  InfoAboutProductViewController.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 05.03.2021.
//

import UIKit


class InfoAboutProductViewController: UIViewController {
    
    @IBOutlet weak var barCodeLabel: UILabel!
    
    private var viewModel: InfoAboutProductViewMOdelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.isTranslucent = true
    }

}






