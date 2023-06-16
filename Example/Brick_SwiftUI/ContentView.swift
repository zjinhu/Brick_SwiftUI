//
//  ContentView.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/5/12.
//

import SwiftUI
import Brick_SwiftUI
struct ContentView: View {

    @State private var showSheet = false

 
    var body: some View {
        Brick.NavigationStack {
            List{
                
                Section {
                    NavigationLink("NavigationStack", destination: NavigationStack())
                    
                    NavigationLink("OpenURL", destination: OpenURLView())
                    
                    NavigationLink("ShareLink", destination: ShareLinkView())
                    
                    if #available(iOS 16.0, *) {
                        NavigationLink("Photo", destination: PhotoPickerView())
                    }
                    
                    NavigationLink("AsyncImage", destination: AsyncImageView())
                    
                    NavigationLink("ScrollView", destination: ScrollsView())
                }

                Section {
                    NavigationLink("Quicklook", destination: QuicklookView())
                    
                    NavigationLink("BadgeView", destination: BadgeView())
                    
                    NavigationLink("SafeAreaPadding", destination: SafeAreaPaddingView())
                    
                    NavigationLink("Presentation", destination: PresentationView())

                    NavigationLink("FocusState", destination: FocusStateView())
                    
                    NavigationLink("AnimationCompleted", destination: AnimationCompleted())
                    
                    NavigationLink("DrrkModelView", destination: DrrkModelView())
                }

            }
            .navigationTitle("Brick_SwiftUI")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        showSheet.toggle()
                    } label: {
                        Text("Sheet")
                    }
                }
            }
            .sheet(isPresented: $showSheet) {
                SwiftUIView()
            }
            .ss.bottomSafeAreaInset {
                Button {
                    
                } label: {
                    Text("BottomSafeAreaInset")
                        .frame(width: 100, height: 50)
                        .background {
                            Color.orange
                        }
                }
                
            }
        }
        
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

