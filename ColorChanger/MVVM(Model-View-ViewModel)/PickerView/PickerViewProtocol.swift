//
//  PickerViewProtocol.swift
//  ColorChanger
//
//  Created by Vivek iLeaf on 10/12/17.
//  Copyright © 2017 Vivek iLeaf. All rights reserved.
//

import Foundation
import UIKit

@objc protocol PickerViewProtocol:class
{
    func didLoad(target:PickerViewController)
     func imagePicker(target:PickerViewController)
     func applyEdit(target:PickerViewController)
    func pickColor(sender:UITapGestureRecognizer)
}
