//
//  ViewController.swift
//  fiztehradio
//
//  Created by Aleksey Bykhun on 23.03.2018.
//  Copyright © 2018 caffeinum. All rights reserved.
//

import UIKit
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

    override func viewDidLoad() {
        super.viewDidLoad()

        player.delegate = self
        player.radioURL = RADIO_URL

        playRadio()

        setupBackgroundWebView()
    }

    func updateUI() {
        let image = isPlaying ? #imageLiteral(resourceName: "pause") : #imageLiteral(resourceName: "play")
        playbackButton.setImage(image, for: .normal)
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

// MARK: - FPlayerDelegate
extension ViewController: FRadioPlayerDelegate {
    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayerState) {
        print("player", player, state.description)
    }

    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
        print("playback", state.description)

        isPlaying = state == .playing
    }
}



