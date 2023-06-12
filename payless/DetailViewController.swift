//
//  DetailViewController.swift
//  payless
//
//  Created by Mert Ünver on 17.12.2022.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var overView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overView.layer.cornerRadius = 25
    }


}
