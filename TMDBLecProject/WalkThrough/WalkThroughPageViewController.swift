//
//  WalkThroughPageViewController.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/16.
//

import UIKit

class WalkThroughPageViewController: UIPageViewController {

    var viewControllerList: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllerList = getViewControllers()
        configureViewController()
        self.view.backgroundColor = #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)
    }
    
    private func getViewControllers() -> [UIViewController] {
        
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: FirstIntroViewController.identifier) as! FirstIntroViewController
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: SecondIntoViewController.identifier) as! SecondIntoViewController
        let vc3 = self.storyboard?.instantiateViewController(withIdentifier: ThirdIntroViewController.identifier) as! ThirdIntroViewController
        let vc4 = self.storyboard?.instantiateViewController(withIdentifier: ForthIntroViewController.identifier) as! ForthIntroViewController
        
        return [vc1, vc2, vc3, vc4]
    }
    
    private func configureViewController() {
        
        delegate = self
        dataSource = self
        
        // display
        guard let first = viewControllerList.first else { return }
        
        setViewControllers([first], direction: .forward, animated: true)
    }
    
}


extension WalkThroughPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print(#function)
        guard let viewControllerIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        return previousIndex < 0 ? nil : viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print(#function)
        guard let viewControllerIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        return nextIndex >= viewControllerList.count ? nil : viewControllerList[nextIndex]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        print(#function)
        guard let first = viewControllers?.first, let index = viewControllerList.firstIndex(of: first) else { return 0 }
        
        print("=======", first, index)
        
        return index
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        print(#function)
        return viewControllerList.count
    }
    
}
