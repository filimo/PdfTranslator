//
//  PDFKitRepresentedView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/8/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    @Binding var url: URL?
    static let pdfView = PDFView()

    class Coordinator: NSObject, PDFViewDelegate {
        var parent: PDFKitView
        
        init(_ parent: PDFKitView) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> PDFKitView.Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> PDFView {
        PDFKitView.pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        if PDFKitView.pdfView.document != nil { return }
        if let url = url {
            PDFKitView.pdfView.autoresizingMask = [.flexibleWidth]
            PDFKitView.pdfView.autoScales = true
            PDFKitView.pdfView.document = PDFDocument(url: url)
            PDFKitView.pdfView.delegate = context.coordinator
        }
    }
}

