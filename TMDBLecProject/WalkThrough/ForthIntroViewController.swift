//
//  ForthIntroViewController.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/16.
//

import UIKit

class ForthIntroViewController: UIViewController {
    
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    
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
        시작하기!
        """
        introLabel.numberOfLines = 2
        introLabel.alpha = 0
        introLabel.textAlignment = .right
        
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = .clear
        startButton.titleLabel?.font = .boldSystemFont(ofSize: 26)
        
        startButton.layer.cornerRadius = 16
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        startButton.clipsToBounds = true
        startButton.alpha = 0
    }
    
    private func animate() {
        
        UIView.animate(withDuration: 2) {
            self.introLabel.alpha = 1
        } completion: { _ in
            self.buttonAppear()
        }
        
    }

    private func buttonAppear() {
        UIView.animate(withDuration: 1) {
            self.startButton.alpha = 1
        } completion: { _ in
            
        }

    }
    
    private func hasAppLaunched() {
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isFirstLaunched)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        
        // iOS13+ SceneDelegate를 쓸 때 동작하는 코드
        // 앱을 처음 실행하는 것 처럼 동작하게 한다.
        // SceneDelegate 밖에서 window에 접근하는 방법
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        // 생명주기 담당
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        guard let vc = UIStoryboard(name: StoryBoradIDs.Main.rawValue, bundle: nil).instantiateViewController(withIdentifier: TrendCollectionViewController.identifier) as? TrendCollectionViewController else { return }
        
        // window에 접근
        sceneDelegate?.window?.rootViewController = UINavigationController(rootViewController: vc)
        sceneDelegate?.window?.makeKeyAndVisible()

//        hasAppLaunched()
    }
}
