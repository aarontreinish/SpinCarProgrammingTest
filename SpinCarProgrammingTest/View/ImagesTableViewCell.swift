//
//  ImagesTableViewCell.swift
//  SpinCarProgrammingTest
//
//  Created by Aaron Treinish on 9/4/19.
//  Copyright © 2019 Treinish. All rights reserved.
//

import UIKit

class ImagesTableViewCell: UITableViewCell {

    @IBOutlet weak var searchedImage: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
