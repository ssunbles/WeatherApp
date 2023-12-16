



//

import Foundation
import UIKit
//MARK: - ReusableCellProtocol
protocol ReusableCellProtocol {
    static var identifier : String { get }
    static var nib : UINib { get }
}

extension ReusableCellProtocol {
    static var identifier : String {
    String(describing: self)
    }
    
    static var nib : UINib {
        UINib(nibName: identifier, bundle: nil)
    }
}

extension UITableViewCell : ReusableCellProtocol {}
extension UICollectionView : ReusableCellProtocol {}
extension UICollectionViewCell : ReusableCellProtocol {}



