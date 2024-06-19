//
//  Toast.swift
//  Example
//
//  Created by 狄烨 on 2023/6/18.
//

import SwiftUI
import BrickKit
#if os(iOS)
struct Toast: View {
    @EnvironmentObject private var toast: ToastManager
    @State var showToast: Bool = false
    @State var showToast1: Bool = false
    var body: some View {
        List {
            
            Section {
                
                Button {
                    toast.position = .top
                    toast.showText("Toast at top")
                    
                } label: {
                    Text("Toast at top")
                }
                
                Button {
                    toast.position = .top
                    toast.showText("Compares less than or equal to all positive numbers, but greater than zero. If the target supports subnormal values, this is smaller than leastNormalMagnitude; otherwise they are equal.")
                    
                } label: {
                    Text("Toast Long Text")
                }
                
                Button {
                    toast.position = .top
                    toast.showCustom()
                    
                } label: {
                    Text("Toast CustomView")
                }
                
            } header: {
                Text("Toast top")
            }
            
            Section {
                Button {
                    toast.position = .bottom
                    toast.showText("Toast at bottom")
                    
                } label: {
                    Text("Toast at bottom")
                }
                
                Button {
                    toast.position = .bottom
                    toast.showText("Compares less than or equal to all positive numbers, but greater than zero. If the target supports subnormal values, this is smaller than leastNormalMagnitude; otherwise they are equal.")
                    
                } label: {
                    Text("Toast Long Text")
                }
                
                Button {
                    toast.position = .bottom
                    toast.showCustom()
                    
                } label: {
                    Text("Toast CustomView")
                }
                
            } header: {
                Text("Toast bottom")
            }
            
            Section {
                
                Button {
                    showToast.toggle()
                } label: {
                    Text("CustomToast")
                }
                
                Button {
                    showToast1.toggle()
                } label: {
                    Text("AlertToast")
                }
                
            } header: {
                Text("CustomToast")
            }
        }
        .addToast(toast)
        .ss.tabBar(.hidden)
        .toast(isPresenting: $showToast1){
            AlertToast(displayMode: .hud,
                       type: .systemImage("exclamationmark.circle.fill", .orange),
                       title: "xxxxxxxxxxxx",
                       style: .style(backgroundColor: .black, titleColor: .white, titleFont: .system(size: 14)))
        }
        .toast(isPresented: $showToast, position: .top, duration: 5.0) {
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
    }
    
}

struct Toast_Previews: PreviewProvider {
    static var previews: some View {
        Toast()
            .environmentObject(ToastManager())
    }
}

extension ToastManager {
    //展示自定义View//自己可以重写替换
    func showCustom(){
        show {
            CustomView()
        }
    }
}


struct CustomView: View {
    var body: some View {
        HStack{
            Image(systemName: "square.and.arrow.up.on.square")
            
            Text("texttexttexttexttext")
            
        }
        .padding(10)
        .foregroundColor(.white)
        .background(
            Color.black
                .opacity(0.8)
                .cornerRadius(10)
        )
    }
}

struct CustomView_Previews: PreviewProvider {
    static var previews: some View {
        CustomView()
    }
}
#endif
