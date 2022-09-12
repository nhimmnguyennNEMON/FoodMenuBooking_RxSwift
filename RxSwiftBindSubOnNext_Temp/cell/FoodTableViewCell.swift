//
//  FoodTableViewCell.swift
//  RxSwiftBindSubOnNext
//
//  Created by V000273 on 08/09/2022.
//

import UIKit

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var imageName: UIImageView!
    @IBOutlet weak var foodname: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageName.layer.cornerRadius = self.imageName.frame.width/4.0
        self.imageName.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
