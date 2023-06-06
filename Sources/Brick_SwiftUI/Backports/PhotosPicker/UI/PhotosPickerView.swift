#if os(iOS)
import SwiftUI
import PhotosUI

internal struct PhotosPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selection: [Brick<Any>.PhotosPickerItem]

    let filter: Brick<Any>.PHPickerFilter?
    let maxSelection: Int?
    let selectionBehavior: Brick<Any>.PhotosPickerSelectionBehavior
    let encoding: Brick<Any>.PhotosPickerItem.EncodingDisambiguationPolicy
    let library: PHPhotoLibrary

    private enum Source: String, CaseIterable, Identifiable {
        var id: Self { self }
        case photos = "Photos"
        case albums = "Albums"
    }

    @State private var source: Source = .photos

    var body: some View {
        NavigationView {
            List {

            }
            .navigationBarTitle(Text("Photos"), displayMode: .inline)
            .toolbar {
                Brick.ToolbarItem(placement: .primaryAction) {
                    Button("Add") {

                    }
                    .font(.body.weight(.semibold))
                    .disabled(selection.isEmpty)
                    .opacity(maxSelection == 1 ? 0 : 1)
                }

                Brick.ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        selection = []
                        dismiss()
                    }
                }

                Brick.ToolbarItem(placement: .principal) {
                    Picker("", selection: $source) {
                        ForEach(Source.allCases) { source in
                            Text(source.rawValue)
                                .tag(source)
                        }
                    }
                    .pickerStyle(.segmented)
                    .fixedSize()
                }

                Brick.ToolbarItem(placement: .bottomBar) {
                    VStack {
                        Text(selection.isEmpty ? "Select Items" : "Selected (\(selection.count))")
                            .font(.subheadline.weight(.semibold))

                        Text("Select up to \(maxSelection ?? 1) items.")
                            .foregroundColor(.secondary)
                            .font(.footnote)
                    }
                }
            }
        }
        .br.interactiveDismissDisabled()
        .onChange(of: source) { newValue in
            selection = source == .albums ? [.init(itemIdentifier: "")] : []
        }
    }
}
#endif
