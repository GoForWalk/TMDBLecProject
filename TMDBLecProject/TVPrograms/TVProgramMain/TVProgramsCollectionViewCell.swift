//
//  TVProgramsCollectionViewCell.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/09.
//

import UIKit

class TVProgramsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tvProgramsThumbnailView: CommonThumbnail!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func setupUI() {
        tvProgramsThumbnailView.backgroundColor = .lightGray
        tvProgramsThumbnailView.thumbnailImageView.backgroundColor = .orange
        self.contentView.backgroundColor = .lightGray
    }
    
    
}
