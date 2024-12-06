//  ViewController.swift
//  MyMusic
//  Created by Aneesha on 06/11/23.

import UIKit

class BaseViewController: UIViewController {

    @IBOutlet weak var tableVw: UITableView!
    
    var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSongs()
        tableVw.delegate = self
        tableVw.dataSource = self
    }
    
    func configureSongs() {
        songs.append(Song(name: "Joyful Jingle", albumName: "joyful-jingle-173919", artistName: "Jim Farrell", imageName: "joyful_jingle", trackName: "joyful-jingle-173919"))
        songs.append(Song(name: "Silent Night", albumName: "silent-night-background-christmas-music", artistName: "Joseph Mohr", imageName: "silent_night", trackName: "silent-night-background-christmas-music-for-short-video-vlog-174363"))
        songs.append(Song(name: "Whistle Vibes", albumName: "whistle-vibes-172471", artistName: "DJ Frank E", imageName: "whistle_vibes", trackName: "whistle-vibes-172471"))
        songs.append(Song(name: "Drive Breakbeat", albumName: "drive-breakbeat-173062", artistName: "John Gosling Aliases", imageName: "drive_breakbeat", trackName: "drive-breakbeat-173062"))
        songs.append(Song(name: "Vibe On", albumName: "vibe-on-173188", artistName: "Taeyang", imageName: "vibe_on", trackName: "vibe-on-173188"))
        songs.append(Song(name: "Titanium", albumName: "titanium-170190", artistName: "David Guetta", imageName: "titanium", trackName: "titanium-170190"))
        songs.append(Song(name: "The Flashback", albumName: "the-flashback_60sec-2-174160", artistName: "Calvin Harris", imageName: "the-flashback", trackName: "the-flashback_60sec-2-174160"))
        songs.append(Song(name: "Leva Eternity", albumName: "leva-eternity-149473", artistName: "Eternity", imageName: "leva_eternity", trackName: "leva-eternity-149473"))
    }
    
}

extension BaseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicListTableViewCell", for: indexPath)
        let songs = songs[indexPath.row]
        cell.textLabel?.text = songs.name
        cell.detailTextLabel?.text = songs.albumName
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: songs.imageName)

        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //present the player
        
        let position = indexPath.row
        
        //songs
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController else {
            return
        }
        vc.songs = songs
        vc.position = position
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

struct Song {
    let name: String
    let albumName: String
    let artistName: String
    let imageName: String
    let trackName: String
}
