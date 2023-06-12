//
//  TableViewController.swift
//  payless
//
//  Created by Mert Ünver on 17.12.2022.
//

import UIKit

class TableViewController: UITableViewController {



    // MARK: - Table view data source

    @IBOutlet weak var cellView: UIView!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        cellView.layer.borderWidth = 0.25
        cellView.layer.borderColor = UIColor.black.cgColor
        cellView.layer.cornerRadius = 25
        
        cellView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cellView.layer.masksToBounds = false
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOpacity = 0.5
        cellView.layer.shadowRadius = 1
    }
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 0
    }


    

}
class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryTitleLabel: UILabel!
    @IBOutlet weak var countryTextLabel: UILabel!
    @IBOutlet weak var countryImageView: UIImageView!
    
}
