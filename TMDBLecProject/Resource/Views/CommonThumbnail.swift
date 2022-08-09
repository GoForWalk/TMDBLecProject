//
//  CommonThumbnail.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/09.
//

import UIKit

class CommonThumbnail: UIView {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var thumbnailTitleLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
        setupUI()
    }
    
    private func loadView() {
        
        guard let view = UINib(nibName: "CommonThumbnail", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        view.frame = bounds
        view.backgroundColor = .lightGray
        
        self.addSubview(view)
    }
    
    private func setupUI() {
        thumbnailTitleLabel.textColor = .white
        thumbnailTitleLabel.font = .boldSystemFont(ofSize: 14)
    }
}
