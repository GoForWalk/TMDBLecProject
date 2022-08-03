//
//  ReusableProtocol.swift
//  TMDBLecProject
//
//  Created by sae hun chung on 2022/08/03.
//

import Foundation
import UIKit

protocol ReusableProtocol {
    
    static var identifier: String { get }
    
}

extension UIViewController: ReusableProtocol {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

extension UICollectionViewCell: ReusableProtocol {
    
    static var identifier: String {
        return String(describing: self)
    }
}
