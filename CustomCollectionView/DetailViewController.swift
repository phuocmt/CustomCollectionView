//
//  DetailViewController.swift
//  CustomCollectionView
//
//  Created by AST-iMac-0015 on 7/2/16.
//  Copyright © 2016 AST-iMac-0015. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    var paper: Paper?

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let paper = paper {
            navigationItem.title = paper.caption
            imageView.image = UIImage(named: paper.imageName)
        }
    }


}
