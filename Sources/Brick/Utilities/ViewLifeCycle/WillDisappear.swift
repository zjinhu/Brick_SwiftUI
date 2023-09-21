//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/7/11.
//

import SwiftUI
#if os(iOS)
import UIKit

struct WillDisappearHandler: UIViewControllerRepresentable {

    let onWillDisappear: () -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        ViewWillDisappearViewController(onWillDisappear: onWillDisappear)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    private class ViewWillDisappearViewController: UIViewController {
        let onWillDisappear: () -> Void

        init(onWillDisappear: @escaping () -> Void) {
            self.onWillDisappear = onWillDisappear
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            onWillDisappear()
        }
    }
}

public extension View {
    func onWillDisappear(_ perform: @escaping () -> Void) -> some View {
        background(WillDisappearHandler(onWillDisappear: perform))
    }
}

#endif
