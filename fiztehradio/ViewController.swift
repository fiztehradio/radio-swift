//
//  ViewController.swift
//  fiztehradio
//
//  Created by Aleksey Bykhun on 23.03.2018.
//  Copyright © 2018 caffeinum. All rights reserved.
//

import UIKit
import MediaPlayer
import FRadioPlayer
import WebKit

let RADIO_URL_STRING = "http://radio.mipt.ru:8410/stream"
let RADIO_URL = URL(string: RADIO_URL_STRING)!
let RADIO_WEBSITE_URL = URL(string: "http://radio.mipt.ru")!

class ViewController: UIViewController {
    let player = FRadioPlayer.shared

    @IBOutlet weak var backgroundWebView: WKWebView!
    @IBOutlet weak var playbackButton: UIButton!
    var isPlaying: Bool = false {
        didSet {
            updateUI()
        }
    }
    var meta: [String: Any?] = [
        MPMediaItemPropertyArtist: "Физтех",
        MPMediaItemPropertyTitle: "Радио",
    ]
        {
            didSet {
                update(meta)
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()

        player.delegate = self
        player.radioURL = RADIO_URL

        playRadio()

        setupBackgroundWebView()
        setupCommands()
    }

    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.endReceivingRemoteControlEvents()
    }

    func updateUI() {
        let image = isPlaying ? #imageLiteral(resourceName: "pause") : #imageLiteral(resourceName: "play")
        playbackButton.setImage(image, for: .normal)

        update()
    }

    func playRadio() {
        player.play()
    }

    func setupBackgroundWebView() {
        let request = URLRequest(url: RADIO_WEBSITE_URL)
        backgroundWebView.load(request)
    }
}

// MARK: - Actions
extension ViewController {
    @IBAction func toggleRadio() {
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }
}

// MARK: - Notification Center
extension ViewController {
    func setupCommands() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.nextTrackCommand.isEnabled = false
        commandCenter.previousTrackCommand.isEnabled = false

        commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            if !self.player.isPlaying {
                self.player.play()

                if !self.player.isPlaying {
                    return .commandFailed
                } else {
                    return .success
                }
            }

            return .success
        }

        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.toggleRadio()
            return .success
        }

    }

    func update(_ meta: [String: Any?]? = nil) {
        let infoCenter = MPNowPlayingInfoCenter.default()

        infoCenter.nowPlayingInfo = meta ?? self.meta

        infoCenter.playbackState = isPlaying ? .playing : .paused

    }
}

// MARK: - FPlayerDelegate
extension ViewController: FRadioPlayerDelegate {
    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayerState) {
        print("player", player, state.description)
    }

    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
        print("playback", state.description)

        isPlaying = state == .playing
    }

    func radioPlayer(_ player: FRadioPlayer, metadataDidChange artistName: String?, trackName: String?) {
        print("metadata", artistName ?? "Unknown artist", trackName ?? "01. Track 1")

        meta[MPMediaItemPropertyArtist] = artistName ?? "Unknown artist"
        meta[MPMediaItemPropertyTitle] = trackName ?? "01. Track 1"
    }

    func radioPlayer(_ player: FRadioPlayer, artworkDidChange artworkURL: URL?) {
        guard let url = artworkURL else { return }

        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async {
                self.meta[MPMediaItemPropertyArtwork] =
                    MPMediaItemArtwork.init(boundsSize: .zero) { _ in UIImage(data: data!)! }
                //    MPMediaItemArtwork.init(image: image!)
            }
        }).resume()
    }

    func radioPlayer(_ player: FRadioPlayer, metadataDidChange rawValue: String?) {
        print("metadata", rawValue ?? "empty")
    }
}

// MARK: - Media Center Actions
extension ViewController: MPMediaPickerControllerDelegate {
}

