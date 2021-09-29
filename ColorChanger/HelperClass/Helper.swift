//
//  Helper.swift
//  ColorChanger
//
//  Created by Vivek iLeaf on 10/12/17.
//  Copyright © 2017 Vivek iLeaf. All rights reserved.
//

import Foundation
import UIKit
class Helper
{
    
    /// Popup Message
    ///
    /// - Parameters:
    ///   - targetVC: corresponding view controller for the viewmodel
    ///   - title: Alert Message Title
    ///   - message: detailed description if needed
    static  func showAlertViewDismissAutomatically(_ targetVC: UIViewController, title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        targetVC.present(alert, animated: true, completion: nil)
        DispatchQueue.main.async { () -> Void in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) { () -> Void in
                targetVC.dismiss(animated: true, completion: nil)
            }
        }
    }
}


// MARK: - Extension For UIColor
extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
}
