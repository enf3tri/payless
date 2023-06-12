//
//  TableViewCell.swift
//  payless
//
//  Created by Mert Ünver on 17.12.2022.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var companyLogo: UIImageView!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}
class RTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var companyLogo: UIImageView!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        companyLogo.image = UIImage(named:companyName.text ?? "Starbucks")
    }

}
