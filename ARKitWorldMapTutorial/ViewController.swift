//
//  ViewController.swift
//  ARKitWorldMapTutorial
//
//  Created by Hung Bui Van on 6/22/19.
//  Copyright © 2019 MyPrint. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var label: UILabel!
    
    @IBAction func resetBarButtonItemDidTouch(_ sender: UIBarButtonItem) {
        resetTrackingConfiguration()
    }
    
    @IBAction func saveBarButtonItemDidTouch(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func loadBarButtonItemDidTouch(_ sender: UIBarButtonItem) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self // 0
        configureLighting() // 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetTrackingConfiguration() // 2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause() // 3
    }
    
    func configureLighting() {
        // 4
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func resetTrackingConfiguration(with worldMap: ARWorldMap? = nil) {
        let configuration = ARWorldTrackingConfiguration()    // 5
        configuration.planeDetection = [.horizontal]    // 6
        
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]    // 7
        
        sceneView.debugOptions = [.showFeaturePoints]     // 8
        sceneView.session.run(configuration, options: options) // 9
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 1
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        // 2
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        // 3
        plane.materials.first?.diffuse.contents = UIColor.lightGray
        
        // 4
        let planeNode = SCNNode(geometry: plane)
        
        // 5
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        
        // 6
        node.addChildNode(planeNode)
    }
}
