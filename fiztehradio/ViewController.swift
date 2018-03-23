//
//  ViewController.swift
//  fiztehradio
//
//  Created by Aleksey Bykhun on 23.03.2018.
//  Copyright © 2018 caffeinum. All rights reserved.
//

import UIKit
import FRadioPlayer

let RADIO_URL_STRING = "http://radio.mipt.ru:8410/stream"
let RADIO_URL = URL(string: RADIO_URL_STRING)!

class ViewController: UIViewController {
    let player = FRadioPlayer.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        player.delegate = self
        player.radioURL = RADIO_URL

        playRadio()
    }

    func playRadio() {
        player.play()
    }
}

extension ViewController: FRadioPlayerDelegate {
    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayerState) {
        print("player", player, state.description)
    }

    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
        print("playback", state.description)

    }
}



