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
    @State var selectedText = ""
    let url = Bundle.main.url(forResource: "sample", withExtension: "pdf")!
    var willChangeSelectedText = PassthroughSubject<String, Never>()
    
    func selectionChanged(event: Notification) {
        if let pdfView = event.object as? PDFView {
            if let selections = pdfView.currentSelection?.selectionsByLine() {
                let text = selections
                    .map { selection in selection.string! }
                    .joined(separator: " ")
                willChangeSelectedText.send(text)
            }
        }
    }
    
    var body: some View {
        HStack {
            PDFKitView(url: url)
            WebView(text: .constant(URLQueryItem(name: "text", value: selectedText)))
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: .PDFViewSelectionChanged, object: nil, queue: nil, using: self.selectionChanged(event:))
            _ = self.willChangeSelectedText
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { text in
                    SpeechSynthesizer.speech(text: text)
                    self.selectedText = text
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
