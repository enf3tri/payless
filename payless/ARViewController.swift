//
//  ARViewController.swift
//  payless
//
//  Created by Mert Ünver on 16.12.2022.
//

import UIKit
import RealityKit

class ARViewController: UIViewController {
   
    @IBOutlet var arvView: ARView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.setHidesBackButton(true, animated: true)
            // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        arvView.scene.anchors.append(boxAnchor)

    }
}



