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

public class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var player: AVAudioPlayer?
    
    @MainActor
    public func play(audio: Audio) async throws {
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
    public func stop() async {
#if os(iOS)
        player?.stop()
        player = nil
#endif
    }

#if os(iOS)
    @MainActor
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { await stop() }
    }
#endif
}
