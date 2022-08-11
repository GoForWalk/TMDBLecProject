//
//  TVProgramsTableViewCell.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/09.
//

import UIKit

class TVProgramsTableViewCell: UITableViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var tvProgramsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        tvProgramsCollectionView.collectionViewLayout = setCollectionViewLayout()
    }
    
    func setupUI() {
        genreLabel.font = .boldSystemFont(ofSize: 24)
        genreLabel.textColor = .white
        self.contentView.backgroundColor = .lightGray
        tvProgramsCollectionView.backgroundColor = .lightGray
    }

    func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.itemSize = CGSize(width: 180 * 1.5 , height: 180)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        return layout
    }
}
