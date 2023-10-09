//
//  InfoCollectionViewCell.swift
//  communityaerial
//
//  Created by Lisette HG on 08/10/23.
//

import UIKit

class InfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageConainter: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.viewContainer.layer.cornerRadius = 20
        //self.imageConainter.layer.cornerRadius = 20
        // Initialization code
    }

}
