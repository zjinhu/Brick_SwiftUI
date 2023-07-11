//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/7/11.
//

import SwiftUI
#if os(iOS)
import UIKit

struct DidDisappearHandler: UIViewControllerRepresentable {

    let onDidDisappear: () -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        ViewDidDisappearViewController(onDidDisappear: onDidDisappear)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    private class ViewDidDisappearViewController: UIViewController {
        let onDidDisappear: () -> Void

        init(onDidDisappear: @escaping () -> Void) {
            self.onDidDisappear = onDidDisappear
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            onDidDisappear()
        }
    }
}

public extension View {
    func onDidDisappear(_ perform: @escaping () -> Void) -> some View {
        background(DidDisappearHandler(onDidDisappear: perform))
    }
}

#endif
