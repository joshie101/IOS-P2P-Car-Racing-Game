//
//  ViewController.swift
//  Peer-to-PeerRemote Car Racing
//
//  Created by Joshua Ajakaiye on 2018-11-08.
//  Copyright © 2018 Josh & Chris. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
   

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //Navigate to TrackSelectionViewController
    @IBAction func play(_ sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav");
        if let trackSelectionViewController = storyboard?.instantiateViewController(withIdentifier: "TrackSelectionViewController") as? TrackSelectionViewController {
           navigationController?.pushViewController(trackSelectionViewController, animated: true)
        }
    }
    
    
    //Navigate to DeviceSelectionViewController
    @IBAction func remotePlay(_ sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav");
        if let deviceSelectionViewController = storyboard?.instantiateViewController(withIdentifier: "DeviceSelectionViewController") as? DeviceSelectionViewController {
            navigationController?.pushViewController(deviceSelectionViewController, animated: true)
        }
    }
    
    //Navigate to LeaderboardViewController
    @IBAction func leaderboard(_ sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav");
        if let leaderboardViewController = storyboard?.instantiateViewController(withIdentifier: "LeaderboardViewController") as? LeaderboardViewController {
            navigationController?.pushViewController(leaderboardViewController, animated: true)
        }
    }
    //Navigate to OptionsViewController
    @IBAction func options(_ sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav");
        if let optionsViewController = storyboard?.instantiateViewController(withIdentifier: "OptionsViewController") as? OptionsViewController {
            navigationController?.pushViewController(optionsViewController, animated: true)
        }
    }
}

