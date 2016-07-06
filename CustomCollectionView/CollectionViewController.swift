//
//  CollectionViewController.swift
//  CustomCollectionView
//
//  Created by AST-iMac-0015 on 7/1/16.
//  Copyright © 2016 AST-iMac-0015. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PaperCell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    private var papersDataSource = PapersDataSource()
    
    private var snapshot: UIView?
    private var sourceIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = editButtonItem()
        self.navigationController!.setToolbarHidden(false, animated: false)
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(CollectionViewController.addButtonTapped))
        
        setupToolbar()
        
        self.collectionView?.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        let width = CGRectGetWidth(collectionView!.frame)/3
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize (width: width, height: width)
        self.collectionView?.registerNib(UINib(nibName: "SectionHeaderView", bundle: nil), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(CollectionViewController.handleLongPress))
        collectionView!.addGestureRecognizer(longPressGestureRecognizer)
        
    }
    
    func setupToolbar(){
        var toolBarItems = [UIBarButtonItem]()
        let spaceLeft = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBarItems.append(spaceLeft)
        let trashButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: #selector(CollectionViewController.trashButtonTapped))
        toolBarItems.append(trashButton)
        let spaceRight = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBarItems.append(spaceRight)
        self.setToolbarItems(toolBarItems, animated: true)
        self.navigationController!.toolbarHidden = true
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.navigationItem.rightBarButtonItem?.enabled = !editing
        collectionView!.allowsMultipleSelection = editing
        let indexPaths = collectionView!.indexPathsForVisibleItems() as [NSIndexPath]
        for indexPath in indexPaths {
            collectionView!.deselectItemAtIndexPath(indexPath, animated: false)
            let cell = collectionView!.cellForItemAtIndexPath(indexPath) as! PaperCell
            cell.editing = editing
        }
        if !editing {
            navigationController!.setToolbarHidden(true, animated: animated)
        }
    }
    
    func addButtonTapped () {
        
        let indexPath = papersDataSource.indexPathForNewRandomPaper()
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            self.collectionView!.insertItemsAtIndexPaths([indexPath])
            }, completion: nil)
        
    }
    
    func trashButtonTapped () {
        let indexPaths = collectionView!.indexPathsForSelectedItems()!
        print(indexPaths)
        papersDataSource.deleteItemsAtIndexPaths(indexPaths)
        collectionView!.deleteItemsAtIndexPaths(indexPaths)
    }
    
    private func updateSnapshotView(center: CGPoint, transfrom: CGAffineTransform, alpha: CGFloat) {
        if let snapshot = snapshot {
            snapshot.center = center
            snapshot.transform = transfrom
            snapshot.alpha = alpha
        }
    }
        
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        if editing {
        return
        }
    let location = recognizer.locationInView(collectionView)
    let indexPath = collectionView!.indexPathForItemAtPoint(location)
        switch recognizer.state {
        case .Began:
            if let indexPath = indexPath {
                sourceIndexPath = indexPath
                let cell = collectionView!.cellForItemAtIndexPath(indexPath) as! PaperCell
                snapshot = cell.snapshot
                updateSnapshotView(cell.center, transfrom: CGAffineTransformIdentity, alpha: 0.0)
                collectionView!.addSubview(snapshot!)
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.updateSnapshotView(cell.center, transfrom: CGAffineTransformMakeScale(1.05, 1.05), alpha: 0.95)
                    cell.moving = true
            })
        }
        case .Changed:
          self.snapshot!.center = location
          if let indexPath = indexPath {
            papersDataSource.movePaperAtIndexPath(sourceIndexPath!, toIndexPath: indexPath)
            collectionView!.moveItemAtIndexPath(sourceIndexPath!, toIndexPath: indexPath)
            sourceIndexPath = indexPath
            
            }
        
        
        
        default:
            let cell = collectionView!.cellForItemAtIndexPath(sourceIndexPath!) as! PaperCell
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.updateSnapshotView(cell.center, transfrom: CGAffineTransformIdentity, alpha: 0.0)
                cell.moving = false
                
                }, completion: { (finished: Bool) -> Void in
                self.snapshot!.removeFromSuperview()
                self.snapshot = nil
                })
        }
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.mainScreen().bounds.width, height: 30)
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return papersDataSource.numberOfSections
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return papersDataSource.numberOfPapersInSection(section)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PaperCell
        if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {
            cell.paper = paper
            cell.editing = editing
        }
    
    
        return cell
    }
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView{
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "SectionHeader", forIndexPath: indexPath) as! SectionHeaderView
        if let title = papersDataSource.titleForSectionAtIndexPath(indexPath) {
            sectionHeaderView.title = title
            sectionHeaderView.image = UIImage(named: title)
        }
        return sectionHeaderView
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
     
        let detailViewConroller = DetailViewController(nibName: "DetailViewController", bundle: nil)
        if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {
            detailViewConroller.paper = paper
        }
        if !editing {
        self.navigationController?.pushViewController(detailViewConroller, animated: true)
        }
        else {
        navigationController!.setToolbarHidden(false, animated: true)
    }
        }
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if editing {
            if collectionView.indexPathsForSelectedItems()?.count == 0 {
                navigationController!.setToolbarHidden(true, animated: true)

            }
        }
    }
}
