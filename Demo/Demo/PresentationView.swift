import SwiftUI
import Brick_SwiftUI

struct PresentationView: View {
    @State private var showSheet: Bool = false
    @State private var backgroundInteraction: Brick.PresentationBackgroundInteraction = .disabled
    @State private var contentInteraction: Brick.PresentationContentInteraction = .resizes
    @State private var detents: Set<Brick.PresentationDetent> = [.medium, .large]
    @State private var selection: Brick.PresentationDetent = .medium
    @State private var customRadius: Bool = false
    @State private var cornerRadius: CGFloat = 20
    
    var body: some View {
        NavigationLink {
            List {
                Section {
                    Picker("Background Interaction", selection: $backgroundInteraction) {
                        Text("Disabled")
                            .tag(Brick.PresentationBackgroundInteraction.disabled)
                        
                        Text("Enabled")
                            .tag(Brick.PresentationBackgroundInteraction.enabled)
                        
                        Text("Up to Medium")
                            .tag(Brick.PresentationBackgroundInteraction.enabled(upThrough: .medium))
                        
                        Text("Up to Large")
                            .tag(Brick.PresentationBackgroundInteraction.enabled(upThrough: .large))
                    }
                    .pickerStyle(.menu)
                    
                    Picker("Content Interaction", selection: $contentInteraction) {
                        Text("Resizes")
                            .tag(Brick.PresentationContentInteraction.resizes)
                        
                        Text("Scrolls")
                            .tag(Brick.PresentationContentInteraction.scrolls)
                    }
                    .pickerStyle(.menu)
                }
                
                Section {
                    Button {
                        showSheet = true
                    } label: {
                        Text("Show Sheet")
                    }
                }
                .sheet(isPresented: $showSheet) {
                    SheetView(detents: $detents, selection: $selection, customRadius: $customRadius, cornerRadius: $cornerRadius)
                        .presentationDetentsIfAvailable(
                            detents: detents,
                            selection: $selection,
                            backgroundInteraction: backgroundInteraction,
                            contentInteraction: contentInteraction,
                            cornerRadius: customRadius ? cornerRadius : nil
                        )
                }
            }
        } label: {
            Text("Presentation")
        }
#if !os(xrOS)
        .ss.tabBar(.hidden)
#endif
    }
}

private struct SheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var visible: Brick.Visibility = .hidden
    @State private var isModal: Bool = false
    @State private var enablePrompt: Bool = true
    @State private var showPrompt: Bool = false
    
    @Binding var detents: Set<Brick<Any>.PresentationDetent>
    @Binding var selection: Brick<Any>.PresentationDetent
    @Binding var customRadius: Bool
    @Binding var cornerRadius: CGFloat
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Toggle("Custom Radius", isOn: $customRadius.animation())
                    
                    if customRadius {
                        Slider(value: $cornerRadius, in: 0...100)
                    }
                }
                
                Section {
                    Button {
                        visible = visible == .hidden ? .visible : .hidden
                    } label: {
                        Text(visible == .visible ? "Hide Grabber" : "Show Grabber")
                    }
                    
                    Button {
                        selection = selection == .medium ? .large : .medium
                    } label: {
                        Text(selection == .medium ? "Expand" : "Collapse")
                    }
                    .disabled(detents.count == 1)
                }
                
                Section {
                    Button {
                        detents = [.large]
                        selection = .large
                    } label: {
                        Text("Expanded Only")
                            .ss.checkmark(detents == [.large] ? .visible : .hidden)
                    }
                    
                    Button {
                        detents = [.medium]
                        selection = .medium
                    } label: {
                        Text("Collapsed Only")
                            .ss.checkmark(detents == [.medium] ? .visible : .hidden)
                    }
                    
                    Button {
                        detents = [.medium, .large]
                    } label: {
                        Text("Both")
                            .ss.checkmark(detents == [.medium, .large] ? .visible : .hidden)
                    }
                }
                
                Section {
                    Button {
                        withAnimation { isModal.toggle() }
                    } label: {
                        Text("Modal")
                            .ss.checkmark(isModal ? .visible : .hidden)
                    }
                    
#if os(iOS)
                    if isModal {
                        Button {
                            enablePrompt.toggle()
                        } label: {
                            Text("Prompt on Dismiss")
                                .ss.checkmark(enablePrompt ? .visible : .hidden)
                        }
                        .actionSheet(isPresented: $showPrompt) {
                            ActionSheet(title: Text("Dismiss"), buttons: [
                                .default(Text("OK")) {
                                    dismiss()
                                },
                                .cancel()
                            ])
                        }
                    }
#endif
                }
            }
//            .listStyle(.insetGrouped)
            .navigationTitle("Sheet")
            .toolbar {
                ToolbarItem {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .ss.presentationDragIndicator(visible)
        .ss.interactiveDismissDisabled(isModal) {
            if enablePrompt { showPrompt = true }
        }
    }
}

extension View {
    @ViewBuilder
    func presentationDetentsIfAvailable(
        detents: Set<Brick<Any>.PresentationDetent>,
        selection: Binding<Brick<Any>.PresentationDetent>,
        backgroundInteraction: Brick<Any>.PresentationBackgroundInteraction,
        contentInteraction: Brick<Any>.PresentationContentInteraction,
        cornerRadius: CGFloat?
    ) -> some View {
        if #available(iOS 15, *) {
            ss.presentationDetents(detents, selection: selection)
                .ss.presentationBackgroundInteraction(backgroundInteraction)
                .ss.presentationContentInteraction(contentInteraction)
                .ss.presentationCornerRadius(cornerRadius)
        } else {
            self
        }
    }
} 
