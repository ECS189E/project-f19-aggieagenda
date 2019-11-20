//
//  ViewController.swift
//  ecs189final
//
//  Created by Arthur on 11/13/19.
//  Copyright © 2019 ucdavis.189. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    
   
    

    @IBOutlet weak var Calendar: UICollectionView!
    @IBOutlet weak var Month: UILabel!
    
    
    @IBAction func Next(_ sender: UIButton) {
    }
    
    @IBAction func Back(_ sender: UIButton) {
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           <#code#>
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           <#code#>
       }

}

