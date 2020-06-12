//
//  ViewController.swift
//  Measury
//
//  Created by Bhavik Kothari on 2020-06-12.
//  Copyright © 2020 Bhavik Kothari. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchLocation = touches.first?.location(in: sceneView){
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResults.first {
                addDot(at: hitResult)
            }
        }
    }
    
    func addDot(at hitResult: ARHitTestResult){
        
        let dotGeometry = SCNSphere(radius: 0.005)
        
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.red
        
        dotGeometry.materials = [material]
        
        let node = SCNNode(geometry: dotGeometry)
        
        node.position = SCNVector3(x: hitResult.worldTransform.columns.3.x, y: hitResult.worldTransform.columns.3.y, z: hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(node)
        
        dotNodes.append(node)
        
        if dotNodes.count >= 2 {
            calculateDistance()
        }
            
    }
    
    func calculateDistance(){
        
        let start = dotNodes[0]
        
        let end = dotNodes[1]
        
        let a = end.position.x - start.position.x
        
        let b = end.position.y - start.position.y
        
        let c = end.position.z - start.position.z
        
        let distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2) )
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
}
