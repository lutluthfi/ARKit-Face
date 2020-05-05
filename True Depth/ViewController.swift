//
//  ViewController.swift
//  True Depth
//
//  Created by Sai Kambampati on 2/23/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var faceLabel: UILabel!
    @IBOutlet weak var labelView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelView.layer.cornerRadius = 10
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let faceMesh = ARSCNFaceGeometry(device: sceneView.device!)
        let node = SCNNode(geometry: faceMesh)
        node.geometry?.firstMaterial?.fillMode = .lines
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry {
            faceGeometry.update(from: faceAnchor.geometry)
            
            DispatchQueue.main.async {
                self.expression(anchor: faceAnchor)
            }
            
        }
    }
    
    func expression(anchor: ARFaceAnchor) {
        print("Look at point: \(anchor.lookAtPoint)")
        print("Geometry: \(anchor.geometry)")
        
        if -0.05...0.05 ~= anchor.lookAtPoint.x && -0.05...0.05 ~= anchor.lookAtPoint.y {
            self.faceLabel.text = "Kamu tidak menghadap kemana-mana"
        }
        
        if anchor.lookAtPoint.x > 0.4 {
            self.faceLabel.text = "Kamu menghadap ke kiri"
        }
        
        if anchor.lookAtPoint.x < -0.4 {
            self.faceLabel.text = "Kamu menghadap ke kanan"
        }
        
        if anchor.lookAtPoint.y > 0.3 {
            self.faceLabel.text = "Kamu menghadap ke bawah"
        }
        
        if anchor.lookAtPoint.y < -0.3 {
            self.faceLabel.text = "Kamu menghadap ke atas"
        }
    }
}
