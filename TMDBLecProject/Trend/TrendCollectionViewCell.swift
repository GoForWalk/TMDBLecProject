//
//  TrendCollectionViewCell.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/03.
//

import UIKit

import Kingfisher

class TrendCollectionViewCell: UICollectionViewCell {
    
    let genreDB = GenreDB.shared
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var trendGenreLabel: UILabel!
    @IBOutlet weak var trendMainImageView: UIImageView!
    @IBOutlet weak var trendRateLabel: UILabel!
    @IBOutlet weak var trendTitleLabel: UILabel!
    @IBOutlet weak var trendDescriptionLabel: UILabel!
    
    @IBOutlet weak var trendDetailButton: UIButton!
    
    @IBOutlet weak var trendContentView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var DetailView: UIView!

    @IBOutlet weak var seperatorView: UIView!
    
    func setData(trendData: TrendData) {
        
        dateLabel.text = " \(trendData.date) "
        trendGenreLabel.text = trendData.genres.map {
            return "#\(genreDB.searchGenreFromData(key: $0)!)"
        }.formatted()
        
        guard let url = URL(string: "\(EndPoint.imageURL)\(trendData.imageURLString)") else { return }
        trendMainImageView.kf.setImage(with: url)
        
        trendRateLabel.text = " \(trendData.rate) "
        trendTitleLabel.text = trendData.title
        trendDescriptionLabel.text = trendData.description
    }
    
    func configureCell() {
        setCellUI()
    }
    
    func setCellUI() {
        setLayer()
    }
    
    func setLayer() {
//        shadowView.clipsToBounds = true
//        shadowView.backgroundColor = .clear
//        shadowView.layer.cornerRadius = 8
//
        trendContentView.clipsToBounds = true
        trendContentView.layer.masksToBounds = false
        trendContentView.layer.borderColor = UIColor.white.cgColor
        trendContentView.layer.shadowColor = UIColor.black.cgColor
        trendContentView.layer.shadowOpacity = 1
        trendContentView.layer.shadowRadius = 6
        trendContentView.layer.shadowOffset = CGSize(width: 1, height: 1)
        trendContentView.backgroundColor = .clear
        
        shadowView.layer.cornerRadius = 12
        shadowView.clipsToBounds = true
        shadowView.layer.masksToBounds = true
        shadowView.backgroundColor = .white
        
        seperatorView.backgroundColor = .black
    }
    
}
