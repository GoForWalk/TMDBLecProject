//
//  FirstIntroViewController.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/16.
//

import UIKit

class FirstIntroViewController: OrientationPortraitLockedViewController {
    
    @IBOutlet weak var introLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animate()
    }
    
    private func configViewController() {
        self.view.backgroundColor = #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)
        
        introLabel.font = .boldSystemFont(ofSize: 28)
        introLabel.textColor = .white
        introLabel.text = """
        현재 '핫'한
        TV 프로그램의 순위
        편하게 찾아보세요!!
        """
        introLabel.numberOfLines = 3
        introLabel.alpha = 0
        introLabel.textAlignment = .right
    }
    
    private func animate() {
        
        UIView.animate(withDuration: 2) {
            self.introLabel.alpha = 1
        } completion: { _ in
            
        }
        
    }
    
    
}
