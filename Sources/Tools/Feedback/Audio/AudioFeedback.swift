import SwiftUI
public extension AnyFeedback {
    /// Specifies feedback that plays an audio file
    /// - Parameter audio: The audio to play when this feedback is triggered
    static func audio(_ audio: Audio) -> Self {
        .init(AudioFeedback(audio: audio))
    }
}

private struct AudioPlayerEnvironmentKey: EnvironmentKey {
    static var defaultValue: AudioPlayer = .init()
}

private extension EnvironmentValues {
    var audioPlayer: AudioPlayer {
        get { self[AudioPlayerEnvironmentKey.self] }
        set { self[AudioPlayerEnvironmentKey.self] = newValue }
    }
}

public struct AudioFeedback: Feedback, ViewModifier {
    @Environment(\.audioPlayer) private var player
    public typealias Body = Never
    
    var audio: Audio
    
    public init(audio: Audio) {
        self.audio = audio
    }
    
    public func perform() async {
        do {
            try await player.play(audio: audio)
        } catch {
            print(error)
        }
    }
}
