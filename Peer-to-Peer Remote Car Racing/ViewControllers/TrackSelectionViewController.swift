//
//  TrackSelectionViewController.swift
//  Peer-to-Peer Remote Car Racing
//
//  Created by user145437 on 11/16/18.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import UIKit
import SpriteKit

class TrackSelectionViewController: UIViewController {

    var track:String = "Track1";
    @IBOutlet weak var trackImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        updateTrackImage();
    }
    

    func updateTrackImage() {
        if let scene = BaseGameScene(fileNamed: self.track) {
          
            let scale =  scene.trackSize.width / scene.size.width;
            scene.camera?.setScale(scale);
            print(scale);
            scene.displayLapLabel();
            
            if let view = self.view as! SKView? {
                let texture = view.texture(from: scene);
            
                let img = UIImage(cgImage: (texture?.cgImage())!);
                trackImage.contentMode = .scaleAspectFill
                print(trackImage.frame.size);
                trackImage.image = img;
                print(trackImage.frame.size);
                
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func start(_ sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
        if let gameViewController = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController {
            
            gameViewController.carType = "TODO";
            gameViewController.track = "Track1";
            
            navigationController?.pushViewController(gameViewController, animated: true)
        }
    }
    @IBAction func backButton(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
    }
}
