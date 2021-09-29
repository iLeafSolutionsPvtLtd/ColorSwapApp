//
//  ViewController.swift
//  ColorChanger
//
//  Created by Vivek iLeaf on 10/12/17.
//  Copyright © 2017 Vivek iLeaf. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController
{
    var delegate : PickerViewProtocol? = nil
    
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var pickedImage: UIImageView!
    var isEditgo = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = PickerViewModel() as PickerViewProtocol
        
        
        self.delegate?.didLoad(target: self)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Image Picker Action
    @IBAction func pickImageAction(_ sender: UIButton)
    {
   self.delegate?.imagePicker(target: self)
    }
    // MARK: - Applying Edit Action
    @IBAction func applyEditButtonaction(_ sender: UIButton)
    {
    self.delegate?.applyEdit(target: self)
    }

    
}

