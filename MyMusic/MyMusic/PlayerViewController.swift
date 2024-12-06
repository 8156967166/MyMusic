//
//  PlayerViewController.swift
//  MyMusic
//
//  Created by Aneesha on 06/11/23.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var holderView: UIView!
    
    public var position: Int = 0
    public var songs: [Song] = []
    
    var player: AVAudioPlayer?
    
    //Userinterface elements
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 //line wrap
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 //line wrap
        return label
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 //line wrap
        return label
    }()
    
    let playPauseButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holderView.subviews.count == 0 {
            configure()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.stop()
        }
    }
    
    func configure() {
        // set up player
        
        let song = songs[position]
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        
        do{
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlString = urlString else {
                return
            }
            
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            
            guard let player = player else {
                return
            }
            player.volume = 0.5
            player.play()
        }
        catch {
            print("Error Occurred")
        }
        
        //set up userinterface elements
        
        //album cover
        
        albumImageView.frame = CGRect(x: 10,
                                      y: 10,
                                      width: holderView.frame.size.width - 20,
                                      height: holderView.frame.size.width - 20)
        albumImageView.image = UIImage(named: song.imageName)
        holderView.addSubview(albumImageView)
        
        //Labels: Song Name, album, Artist
        
        songNameLabel.frame = CGRect(x: 10,
                                     y: albumImageView.frame.size.height + 10,
                                      width: holderView.frame.size.width - 20,
                                      height: 70)
        
        albumNameLabel.frame = CGRect(x: 10,
                                     y: albumImageView.frame.size.height + 10 + 70,
                                      width: holderView.frame.size.width - 20,
                                      height: 70)
        
        artistNameLabel.frame = CGRect(x: 10,
                                     y: albumImageView.frame.size.height + 10 + 140,
                                      width: holderView.frame.size.width - 20,
                                      height: 70)
        
        songNameLabel.text = song.name
        albumNameLabel.text = song.albumName
        artistNameLabel.text = song.artistName
        
        holderView.addSubview(songNameLabel)
        holderView.addSubview(albumNameLabel)
        holderView.addSubview(artistNameLabel)
        
        //player controls
        
        let nextButton = UIButton()
        let backButton = UIButton()
        
        //Frames
        
        let yPosition = artistNameLabel.frame.origin.y + 70 + 20
        let size: CGFloat = 40
        
        playPauseButton.frame = CGRect(x: (holderView.frame.size.width - size) / 2,
                                       y: yPosition,
                                       width: size,
                                       height:  size)
        nextButton.frame = CGRect(x: holderView.frame.size.width - size - 20,
                                  y: yPosition,
                                  width: size,
                                  height:  size)
        backButton.frame = CGRect(x: 20,
                                  y: yPosition,
                                  width: size,
                                  height:  size)
        
        //Add Actions
        
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        //Styling
        
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        
        playPauseButton.tintColor = .black
        nextButton.tintColor = .black
        backButton.tintColor = .black
        
        holderView.addSubview(playPauseButton)
        holderView.addSubview(nextButton)
        holderView.addSubview(backButton)
        
        //Slider
        
        let slider = UISlider(frame: CGRect(x: 20,
                                            y: holderView.frame.size.height - 60,
                                            width: holderView.frame.size.width - 40,
                                            height: 50))
        slider.value = 0.5
        slider.addTarget(self, action: #selector(didSlideSlider), for: .valueChanged)
        holderView.addSubview(slider)
    }
    
    @objc func didTapBackButton() {
        if position > 0 {
            position = position - 1
            player?.stop()
            
            for subView in holderView.subviews {
                subView.removeFromSuperview()
            }
            
            configure()
        }
    }
    
    @objc func didTapPlayPauseButton() {
        if player?.isPlaying == true {
            player?.pause()
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            
            // shrink Image
            
            UIView.animate(withDuration: 0.2) {
                self.albumImageView.frame = CGRect(x: 30,
                                                   y: 30,
                                                   width: self.holderView.frame.size.width - 60,
                                                   height: self.holderView.frame.size.width - 60)
            }
            
        }else {
            player?.play()
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            
            //increase Image Size
            
            UIView.animate(withDuration: 0.2) {
                self.albumImageView.frame = CGRect(x: 10,
                                                   y: 10,
                                                   width: self.holderView.frame.size.width - 20,
                                                   height: self.holderView.frame.size.width - 20)
            }
            
        }
    }
    
    @objc func didTapNextButton() {
        if position < (songs.count - 1) {
            position = position + 1
            player?.stop()
            
            for subView in holderView.subviews {
                subView.removeFromSuperview()
            }
            
            configure()
        }
    }
    
    @objc func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        
        //Adjust player volume
        
        player?.volume = value
        
    }
}
