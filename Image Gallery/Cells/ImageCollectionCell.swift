//
//  ImageCollectionCell.swift
//  Image Gallery
//
//  Created by Sandeep Kumar on 5/10/24.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {

    //MARK:- ====== Outlets ======
    @IBOutlet weak var imgView: UIImageView!
    
    //MARK:- ====== Variables ======
    var objVModel: ImageCollectionCellViewModel? {
        didSet {
            loadData()
        }
    }
    
    //MARK:- ====== Life Cycle ======
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        objVModel?.blockImageUpdate = nil
        print("prepareForReuse")
        objVModel?.cancelRequest()
    }
    
    //MARK:- ====== Functions ======
    func loadData() {
        imgView.image = objVModel?.image
        objVModel?.fetchImage()

        objVModel?.blockImageUpdate = {
            [weak self] image in
            self?.imgView.image = image
        }
    }
}
