//
//  ContentView.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import PDFKit
import Combine

struct ContentView: View {
    @State var currentPage = "1"
    @State var pageCount = 0
    @State var selectedText = ""
    @State var url: URL?
    
    @UserDefault(key: "LAST_PAGE", defaultValue: "1")
    var last_page: String

    private var willChangeSelectedText = PassthroughSubject<String, Never>()
    
    var body: some View {
        VStack {
            HStack {
                PDFKitView(url: $url)
                TranslatorView(text: .constant(URLQueryItem(name: "text", value: selectedText)))
            }
            HStack {
                Button(action: {
                    SpeechSynthesizer.speech(text: self.getSelectedText())
                }) {
                    Image(systemName: "volume.3.fill")
                }
                TextField("   ", text: $currentPage, onCommit: goCurrentPage).fixedSize().background(Color.gray)
                Text(" / \(pageCount)")
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: .PDFViewDocumentChanged, object: nil, queue: nil) { event in
                guard let pdfView = event.object as? PDFView else { return }
                guard let document = pdfView.document else { return }
                
                RunLoop.main.perform {
                    self.currentPage = self.last_page
                    self.goCurrentPage()
                    self.pageCount = document.pageCount
                }
            }

            NotificationCenter.default.addObserver(forName: .PDFViewPageChanged, object: nil, queue: nil) { event in
                guard let pdfView = event.object as? PDFView else { return }
                guard let page = pdfView.currentPage else { return }
                
                if let page = pdfView.document?.index(for: page) {
                    RunLoop.main.perform {
                        self.currentPage = String(page + 1)
                        self.last_page = self.currentPage
                    }
                }
            }

            NotificationCenter.default.addObserver(forName: .PDFViewSelectionChanged, object: nil, queue: nil) { _ in
                self.willChangeSelectedText.send(self.getSelectedText())
            }
            _ = self.willChangeSelectedText
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { text in
                    SpeechSynthesizer.speech(text: text)
                    self.selectedText = text
            }
            
            self.url = Bundle.main.url(forResource: "FunctionalSwift", withExtension: "pdf")
        }
    }
    
    func goCurrentPage() {
        guard let document = PDFKitView.pdfView.document else { return }
        guard let page = Int(currentPage) else { return }
        if let page = document.page(at: page - 1) {
            PDFKitView.pdfView.go(to: page)
        }
    }
    
    func getSelectedText() -> String {
        guard let selections = PDFKitView.pdfView.currentSelection?.selectionsByLine() else { return "" }

        return selections
            .map { selection in selection.string! }
            .joined(separator: " ")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
