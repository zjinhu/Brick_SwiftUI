import SwiftUI
#if canImport(AVFoundation)
import AVFoundation
#endif
private enum PlayerError: LocalizedError {
    case badUrl(Audio)
    var errorDescription: String? {
        switch self {
        case let .badUrl(audio):
            return "Couldn't play sound: \(audio.url.lastPathComponent), the URL was invalid."
        }
    }
}

internal final class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var player: AVAudioPlayer?
    
    @MainActor
    func play(audio: Audio) async throws {
#if os(iOS)
        await stop()

        try AVAudioSession.sharedInstance().setCategory(.ambient)
        try AVAudioSession.sharedInstance().setActive(true)
        
        player = try AVAudioPlayer(contentsOf: audio.url)
        player?.delegate = self
        player?.play()
#endif
    }
    
    @MainActor
    func stop() async {
#if os(iOS)
        player?.stop()
        player = nil
#endif
    }

#if os(iOS)
    @MainActor
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { await stop() }
    }
#endif
}
