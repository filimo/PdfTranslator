//
//  PDFKitRepresentedView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/8/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import PDFKit

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL
    let pdfView = PDFView()

    class Coordinator: NSObject, PDFViewDelegate {
        var parent: PDFKitRepresentedView
        
        init(_ parent: PDFKitRepresentedView) {
            self.parent = parent
        }
    }
    
    init(_ url: URL) {
        self.url = url
    }
    
    func makeCoordinator() -> PDFKitRepresentedView.Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> PDFKitRepresentedView.UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
        pdfView.autoresizingMask = [.flexibleWidth]
        pdfView.autoScales = true
        pdfView.document = PDFDocument(url: self.url)
        pdfView.delegate = context.coordinator
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    }
}

struct PDFKitView: View {
    var url: URL

    var body: some View {
        PDFKitRepresentedView(url)
    }
}


