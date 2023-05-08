//
//  ViewController.swift
//  TournamentManager1
//
//  Created by tamzimun on 23.06.2022.
//

import UIKit
import AVKit

class HomeViewController: UIViewController {
    
    private var videoPlayer:AVPlayer?
    private var videoPlayerLayer:AVPlayerLayer?
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpVideo()
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
        self.navigationController?.pushViewController(signUpViewController!, animated: true)
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func loginButtontapped(_ sender: UIButton) {
        
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        self.navigationController?.pushViewController(loginViewController!, animated: true)
        self.view.window?.makeKeyAndVisible()
    }
    
    func setUpElements() {
        
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }
    
    func setUpVideo() {
        
        let bundlePath = Bundle.main.path(forResource: "teenage-mutant-ninja-turtles-season-5-official-trailer-baby-turtles-aliens_5esaxJkR", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }

        let url = URL(fileURLWithPath: bundlePath!)
        let item = AVPlayerItem(url: url)
        videoPlayer = AVPlayer(playerItem: item)
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        videoPlayer?.playImmediately(atRate: 1)
    }
}

