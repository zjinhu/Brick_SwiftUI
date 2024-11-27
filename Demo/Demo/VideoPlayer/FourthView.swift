//
//  FourthView.swift
//  BrickBrickDemo
//
//  Created by 狄烨 on 2024/11/13.
//

import SwiftUI

struct FourthView: View {
    @State var showView = false
    var body: some View {
        Text("Click there to play video")
            .onTapGesture {
                showView.toggle()
            }
            .sheet(isPresented: $showView) {
                VideoPlayerView()
            }
        
    }
}

#Preview {
    FourthView()
}

import AVKit
import Combine

class VideoPlayerViewModel: ObservableObject {
    @Published var isPlaying = false
    @Published var isLoading = true  // 新增一个属性来跟踪加载状态
    private var player: AVPlayer
    private var cancellables = Set<AnyCancellable>()
    
    init(url: URL) {
        player = AVPlayer(url: url)
        
        // 监听 `timeControlStatus` 以更新播放状态
        player.publisher(for: \.timeControlStatus)
            .map { $0 == .playing }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isPlaying)
        
        // 监听 `isPlaybackLikelyToKeepUp` 以更新加载状态
        player.currentItem?.publisher(for: \.isPlaybackLikelyToKeepUp)
            .map { !$0 } // 如果 `isPlaybackLikelyToKeepUp` 为 `false`，则表示正在加载
            .receive(on: DispatchQueue.main)
            .assign(to: &$isLoading)
        
        // 监听播放结束
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
            .sink { [weak self] _ in
                self?.isPlaying = false
            }
            .store(in: &cancellables)
    }
    
    func getPlayer() -> AVPlayer {
        return player
    }
    
    @MainActor func playPause() {
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }
}

struct VideoPlayerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = VideoPlayerViewModel(url: URL(string: "https://share.ttsharegolf.com/share/Lark20241113-013454.mov")!)
    
    
    var body: some View {
        
        VideoPlayer(player: viewModel.getPlayer())
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden()
            .onAppear{
                viewModel.playPause()
            }
            .onDisappear{
                viewModel.playPause()
            }
            .overlay{
                // 显示加载指示器
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: 100, height: 100)
                        .background(Color.black) // 使加载指示器更明显
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundStyle(.white)
                        .tint(.white)
                }
            }
            .overlay(alignment: .bottom) {
                Button {
                    dismiss()
                } label: {
                    Text("Don't show this again")
                        .foregroundStyle(.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                }
                .background(.black)
                .clipShape(Capsule())
                
            }
    }
}
