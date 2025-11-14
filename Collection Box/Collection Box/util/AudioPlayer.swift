
import AVFoundation
import AudioToolbox

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

// Simple tap sound for UI interactions (e.g., liking an item).
// Uses a built-in system sound so no extra asset is required.
func playTapSound() {
    // 1104 is a light key-press click; adjust if you prefer a different feel.
    AudioServicesPlaySystemSound(1104)
}

