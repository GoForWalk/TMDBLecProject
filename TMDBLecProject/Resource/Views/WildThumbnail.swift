//
//  WildThumbnail.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/04.
//

import UIKit

// XIB -> xml형태로 Interface Builder 구성 정보를 갖는다.
// 컴파일시 nib 파일로 변환되기 떄문에, 이를 사용자의 씬에 출력하기 위해서는 init(coder: NSCoder)를 통해 객체를 생성해야 한다.
class WildThumbnail: UIView {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var opacityView: UIView!
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        loadView()
        loadUI()
    }
    
    //
    private func loadView() {
        // nib 파일을 UIView 객체로 만드는 코드
        guard let view = UINib(nibName: "WildThumbnail", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        
        
        self.addSubview(view)
    }
    
    private func loadUI() {
        // UI의 property들을 설정
        
    }
    
}
