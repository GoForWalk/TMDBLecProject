//
//  CastingTableViewCell.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/04.
//

import UIKit

import Kingfisher

class CastingTableViewCell: UITableViewCell {

    @IBOutlet weak var actorImageView: UIImageView!
    
    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var characterNameLabel: UILabel!
    
    func configueCell() {
        
        actorImageView.layer.cornerRadius = 8
        actorImageView.clipsToBounds = true
        
        actorNameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        characterNameLabel.font = .systemFont(ofSize: 16, weight: .regular)
        characterNameLabel.textColor = .gray
    }
    
    func setData(actor: ActorInfo) {
        
        actorNameLabel.text = actor.actorName
        characterNameLabel.text = actor.characterName
        
        var urlstr = ""
        
        if actor.actorImageURLString == nil {
            urlstr = "https://f4.bcbits.com/img/a4042326307_10.jpg"
        } else {
            
        }
        
         urlstr = "\(EndPoint.imageURL)\(actor.actorImageURLString!)"
        
        guard let url = URL(string: urlstr) else { return }
        
        actorImageView.kf.setImage(with: url)
        
    }
}
