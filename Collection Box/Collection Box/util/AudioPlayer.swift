
import AVFoundation

func playMusic(from url: URL) -> AVPlayer {
    let player = AVPlayer(url: url)
    player.actionAtItemEnd = .none
    
    NotificationCenter.default.addObserver(
        forName: .AVPlayerItemDidPlayToEndTime,
        object: player.currentItem,
        queue: .main
    ) { _ in
        player.seek(to: .zero)
        player.play()
    }
    
    player.play()
    return player
}

