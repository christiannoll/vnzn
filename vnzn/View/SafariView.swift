//
//  SafariView.swift
//  TestMarkdown
//
//  Created by Christian on 24.09.24.
//

import SwiftUI
import SafariServices

struct SafariViewControllerPresenter: UIViewControllerRepresentable {
    let url: URL
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController() // A dummy view controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            let safariVC = SFSafariViewController(url: url)
            safariVC.delegate = context.coordinator
            uiViewController.present(safariVC, animated: true)
        } else {
            uiViewController.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        var parent: SafariViewControllerPresenter
        
        init(_ parent: SafariViewControllerPresenter) {
            self.parent = parent
        }
        
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            // This will be called when the user taps 'Done' in the Safari view
            parent.isPresented = false
        }
    }
}
