//
//  FireCollectionViewCell.swift
//  simulationdead
//
//  Created by Lisette HG on 07/10/23.
//

import UIKit

protocol FireCollectionViewCellDelegate: AnyObject {
    func boomSelected(indexPath: IndexPath?, controller: FireCollectionViewCell)
}

class FireCollectionViewCell: UICollectionViewCell {

    weak var delegate: FireCollectionViewCellDelegate?

    @IBOutlet weak var buttonBom: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageSensor: UIImageView!
    
    var indexPath: IndexPath?
    var isDead = false 
    var animator: UIViewPropertyAnimator?


    override func awakeFromNib() {
        super.awakeFromNib()

        self.viewContainer.layer.cornerRadius = self.viewContainer.frame.width / 2
        animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: {
                  UIView.setAnimationRepeatCount(.greatestFiniteMagnitude)
                  UIView.setAnimationRepeatAutoreverses(true)
            self.imageSensor.tintColor = .red
        })
    }
    
    @IBAction func actionClickBoom(_ sender: Any) {
        self.delegate?.boomSelected(indexPath: self.indexPath, controller: self)
    }
    
    func startBlinking(imageSensor: UIImageView) {
        if self.isDead {
            animator?.startAnimation()
        } else {
            self.imageSensor.tintColor = .white
            animator?.pauseAnimation()
        }
    }

}
