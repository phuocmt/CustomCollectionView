//
//  SectionHeaderView.swift
//  CustomCollectionView
//
//  Created by AST-iMac-0015 on 7/4/16.
//  Copyright © 2016 AST-iMac-0015. All rights reserved.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var headerImage: UIImageView!

    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    var image: UIImage? {
        didSet {
            headerImage.image = image
        }
    }
   override func awakeFromNib() {
      super.awakeFromNib()
        // Initialization code
   }
    
}
