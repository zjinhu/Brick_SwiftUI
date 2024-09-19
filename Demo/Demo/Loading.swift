//
//  Loading.swift
//  Example
//
//  Created by 狄烨 on 2023/6/18.
//

import SwiftUI
import BrickKit

struct Loading: View {
    @EnvironmentObject private var loading: LoadingManager
    @State var showloading = false
    @State var showToast1: Bool = false
    @StateObject var timer = TimeHelp()
    var body: some View {
        List {

            Section {
                Button {
                    loading.text = nil
                    loading.showLoading()
                    dismiss()
                } label: {
                    Text("Loading No Text")
                }
                
                Button {
                    loading.text = "Please wait..."
                    loading.showLoading()
                    dismiss()
                } label: {
                    Text("Loading Short Text")
                }
                
                Button {
                    loading.text = "Please wait. We need some more time to work out this situation."
                    loading.showLoading()
                    dismiss()
                } label: {
                    Text("Loading Longer text")
                }
            } header: {
                Text("Loading")
            }
            
            Section {
                Button {
                    startTimer()
                    loading.text = nil
                    loading.showProgress()
                    
                } label: {
                    Text("Progress No Text")
                }
                
                Button {
                    startTimer()
                    loading.text = "Please wait..."
                    loading.showProgress()
                    
                } label: {
                    Text("Progress Short Text")
                }
                
                Button {
                    startTimer()
                    loading.text = "Please wait. We need some more time to work out this situation."
                    loading.showProgress()
                    
                } label: {
                    Text("Progress Longer text")
                }
            } header: {
                Text("Progress")
            }
            
            Section {
                Button {

                    loading.text = nil
                    loading.showSuccess()
 
                } label: {
                    Text("Success No Text")
                }
                
                Button {

                    loading.text = "Please wait..."
                    loading.showSuccess()
  
                } label: {
                    Text("Success Short Text")
                }
                
                Button {

                    loading.text = "Please wait. We need some more time to work out this situation."
                    loading.showSuccess()
     
                } label: {
                    Text("Success Longer text")
                }
            } header: {
                Text("Success")
            }
            
            Section {
                Button {

                    loading.text = nil
                    loading.showFail()
  
                } label: {
                    Text("Failed No Text")
                }
                
                Button {

                    loading.text = "Please wait..."
                    loading.showFail()
       
                } label: {
                    Text("Failed Short Text")
                }
                
                Button {

                    loading.text = "Please wait. We need some more time to work out this situation."
                    loading.showFail()
         
                } label: {
                    Text("Failed Longer text")
                }
            } header: {
                Text("Failed")
            }
 
            Section {
 
                Button {
                    showloading.toggle()
                } label: {
                    Text("loading")
                }
                
                Button {
                    showToast1.toggle()
                } label: {
                    Text("AlertToast loading")
                }
                
            } header: {
                Text("CustomLoading")
            }
        }
#if os(iOS)
        .ss.tabBar(.hidden)
#endif
        .addLoading(loading)
        .onChange(of: timer.progress) { newValue in
            loading.progress = newValue
            debugPrint("\(loading.progress)")
            if newValue >= 1{
                timer.stop()
                loading.showSuccess()
            }
        }
#if os(iOS)
        .toast(isPresenting: $showToast1){
            AlertToast(displayMode: .alert,
                       type: .loading,
                       title: "Loading...",
                       style: .style(backgroundColor: .black.opacity(0.9), titleColor: .white, titleFont: .system(size: 14)))
        }
        .loading(isPresented: $showloading, options: loadingOptions) {
            Label(
                title: {
                    Text("保存成功")
                        .foregroundColor(.black)
                },
                icon: {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.green)
                }
            )
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(radius: 10)
        }
#endif
    }
#if os(iOS)
    private let loadingOptions = LoadingOptions(
        hideAfter: 5
    )
#endif
    func dismiss(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            loading.hide()
        }
    }
    
    func startTimer(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            timer.startTimer()
        }
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading()
            .environmentObject(LoadingManager())
    }
}

import Combine
class TimeHelp: ObservableObject{
    @Published var progress: CGFloat = 0
    var canceller: AnyCancellable?
    
    func startTimer() {
        let timerPublisher = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
 
        self.canceller = timerPublisher.sink { date in
            self.updateValue()
        }
    }
    
    func updateValue() {
        progress += 0.2
    }
    
    func stop() {
        canceller?.cancel()
        canceller = nil
        progress = 0
    }
}
