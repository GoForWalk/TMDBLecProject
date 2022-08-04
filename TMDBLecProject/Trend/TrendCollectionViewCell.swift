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
    @IBOutlet weak var trendRateInfoLabel: UILabel!
    
    @IBOutlet weak var trendDetailButton: UIButton!
    @IBOutlet weak var lookDetailLabel: UILabel!
    
    @IBOutlet weak var trendContentView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var DetailView: UIView!

    @IBOutlet weak var seperatorView: UIView!
    
    func setData(trendData: TrendData) {
        
        dateLabel.text = " \(trendData.date) "
        trendGenreLabel.text = trendData.genres.map {    
            return "#\(genreDB.searchGenreFromData(key: $0)!)"
        }.formatted(.list(type: .and, width: .narrow))
        
        guard let url = URL(string: "\(EndPoint.imageURL)\(trendData.wildImageURLString)") else { return }
        trendMainImageView.kf.setImage(with: url)
        
        trendRateLabel.text = " \(trendData.rate) "
        trendTitleLabel.text = trendData.title
        trendDescriptionLabel.text = trendData.description
    }
    
    func configureCell() {
        setLayer()
        setFont()
    }
    
    func setLayer() {
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
    
    func setFont() {
        
        dateLabel.font = .systemFont(ofSize: 14, weight: .regular)
        dateLabel.textColor = .gray
        
        trendGenreLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        trendTitleLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        
        trendDescriptionLabel.font = .systemFont(ofSize: 16, weight: .regular)
        trendDescriptionLabel.textColor = .darkGray
        
        lookDetailLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        trendRateLabel.font = .systemFont(ofSize: 14, weight: .regular)
        trendRateInfoLabel.font = .systemFont(ofSize: 14, weight: .regular)
    }
    
}
