//
//  ChangeColorViewController.swift
//  ColorChanger
//
//  Created by Vivek iLeaf on 10/12/17.
//  Copyright © 2017 Vivek iLeaf. All rights reserved.
//

import UIKit

class ChangeColorViewController: UIViewController
{
    var delegate : ChangeColorProtocol? = nil

    var currrentColor = UIColor()
    var input = UIImage()
    var rgb : (Float,Float,Float) = (0,0,0)
     var defaultHue: Float = 0
    @IBOutlet weak var imageView: UIImageView!
    var ciImage: CIImage?
    @IBOutlet weak var horizontalColorPicker: SwiftHUEColorPicker!
    @IBOutlet weak var horizontalSaturationPicker: SwiftHUEColorPicker!
    @IBOutlet weak var horizontalBrightnessPicker: SwiftHUEColorPicker!
    @IBOutlet weak var horizontalAlphaPicker: SwiftHUEColorPicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = ChangeColorViewModel() as ChangeColorProtocol
        self.delegate?.didLoad(target: self)
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    @IBAction func appplyColorButton(_ sender: Any)
    {
        self.delegate?.applyColor(target: self)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
