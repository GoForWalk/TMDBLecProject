//
//  OverviewTableViewCell.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/04.
//

import UIKit

class OverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var overviewLabel: UILabel!
    
    func setData(str: String) {
        
        overviewLabel.text = str
        
    }
    
}
