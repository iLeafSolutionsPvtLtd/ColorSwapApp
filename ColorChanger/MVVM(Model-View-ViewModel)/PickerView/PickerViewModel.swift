//
//  PickerViewModel.swift
//  ColorChanger
//
//  Created by Vivek iLeaf on 10/12/17.
//  Copyright © 2017 Vivek iLeaf. All rights reserved.
//

import Foundation
import UIKit
import Vision
import ImageIO

class PickerViewModel:PickerViewProtocol
{
    
    /// ViewModel Didload
    ///
    /// - Parameter target: corresponding view controller for the viewmodel
    func didLoad(target:PickerViewController)
    {
        target.pickedImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: target.delegate, action: #selector(target.delegate?.pickColor(sender:)))
        target.pickedImage.addGestureRecognizer(tap)
    }
    
    /// ImagePicker view present action
    ///
    /// - Parameter target: corresponding view controller for the viewmodel
    func imagePicker(target:PickerViewController)
    {
        let picker = UIImagePickerController()
        picker.delegate = target
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        target.present(picker, animated: true, completion: nil)
    }
    
    /// Applying edit action
    ///
    /// - Parameter target: corresponding view controller for the viewmodel
    func applyEdit(target:PickerViewController)
    {
        if target.pickedImage.image != nil
        {
            target.isEditgo = true
            Helper.showAlertViewDismissAutomatically(target, title: "Please tap an area of your image to pick color", message: "")
           
        }
        else
        {
            Helper.showAlertViewDismissAutomatically(target, title: "Please pick an image by tapping Pick Image", message: "")
        }
    }
    
    /// UItapgesture action for the parent of this view model
    ///
    /// - Parameter sender: uitapgesture recognizer object
    @objc func pickColor(sender:UITapGestureRecognizer)
    {
        //Derived from the inheritence of the view accessed the target controller
        let target = sender.view?.next?.next as! PickerViewController
        
        guard target.isEditgo else {
            return
        }
        let imgView = sender.view as! UIImageView
        
        let touchLocation: CGPoint = sender.location(in: imgView)
        
        let image = imgView.image
        
        let getImage = drawNewImage(imageView: imgView, imageToCrop: image!, rect: CGRect(x: touchLocation.x, y: touchLocation.y, width: 30, height: 30))
        
        
        let color = getImage.getColors().primary
        
        
        let r = color?.coreImageColor.red
        let g = color?.coreImageColor.green
        let b = color?.coreImageColor.blue
        let rgb :(Float,Float,Float) = (Float(r!),Float(g!),Float(b!))
        let viewController = target.storyboard?.instantiateViewController(withIdentifier: "ChangeColorViewController") as! ChangeColorViewController
        viewController.rgb = rgb
        viewController.input = target.pickedImage.image!
        viewController.currrentColor = color!
        target.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    /// Crop the resized image drawed from the UIImageView
    ///
    /// - Parameters:
    ///   - imageToCrop: input image to crop
    ///   - rect: rect gather from the touch point using tap gesture
    /// - Returns: the new image helps to gather the primary color more refined
    func cropNewImage(byCropping imageToCrop: UIImage, to rect: CGRect) -> UIImage {
        let imageRef = imageToCrop.cgImage?.cropping(to: rect)
        let cropped = UIImage(cgImage: imageRef!)
        return cropped
    }
    
    
    /// Drawing a new image with respect to the imageview
    ///
    /// - Parameters:
    ///   - imageView: corresponding imageview need to be drawn
    ///   - imageToCrop: input image to crop the original one
    ///   - rect: ect gather from the touch point using tap gesture
    /// - Returns: returns the cropped image with respect to the uiimageview
    func drawNewImage(imageView : UIImageView,imageToCrop : UIImage,rect:CGRect)-> UIImage
    {
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.drawHierarchy(in: CGRect(x: 0, y: 0, width: imageView.bounds.width, height: imageView.bounds.height), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return cropNewImage(byCropping: image!, to: rect)
        
    }
}

extension PickerViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate
{
    // MARK: - Image Picker Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        DispatchQueue.main.async {
            self.pickedImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Collection View Delegates & Datasource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photos", for: indexPath) as! PhotocellCollectionViewCell
        cell.imagez.image = UIImage(named:"car\(indexPath.row)")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            self.pickedImage.image = UIImage(named:"car\(indexPath.row)")
        }
    }


}
