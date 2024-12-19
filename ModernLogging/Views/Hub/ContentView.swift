//
//  ContentView.swift
//  ModernLogging
//
//  Created by Sucu, Ege on 6.11.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Query var logs: [MLog]
    @State private var openAddLog: Bool = false
    @Environment(\.modelContext) var modelContext
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(logs) { log in
                    VStack {
                        HStack {
                            Text("Mood")
                                .bold()
                            Spacer()
                            Text(log.mood.rawValue.capitalized)
                        }
                        HStack {
                            Text("Notes")
                                .bold()
                            Spacer()
                            if let notes = log.notes {
                                Text(notes)
                            }
                        }
                        previewImageView(log: log)
                    }
                    .accessibilityIdentifier(
                        AccessibilityIdentifiers
                            .listItem(item: log.date.formatted())
                    )
                }
                .accessibilityIdentifier(
                    AccessibilityIdentifiers.logListView
                )
                .onDelete(perform: removeLogs(from:))
            }
            .navigationTitle("Logs")
            .toolbar {
                ToolbarItem {
                    Button {
                        openAddLog.toggle()
                    } label: {
                        Text("Add Log")
                    }
                    .accessibilityIdentifier(
                        AccessibilityIdentifiers
                            .addLogButton
                    )
                }
            }
        }
        .sheet(
            isPresented: $openAddLog
        ) {
            AddLogView(viewModel: .init())
        }
        .overlay(content: previewImageOverlay)
    }
    
    @ViewBuilder
    func previewImageOverlay() -> some View {
        if let image = selectedImage {
            ZStack {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedImage = nil
                    }
                Image(uiImage: image)
                    .resizable()
                    .clipShape(.rect(cornerRadius: 10))
                    .frame(width: 250, height: 250)
            }
            .animation(.smooth, value: selectedImage)
        }
    }
    
    @ViewBuilder
    func previewImageView(log: MLog) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(log.images, id: \.self) { imageData in
                    if let imageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(.rect(cornerRadius: 10))
                            .onTapGesture {
                                withAnimation {
                                    selectedImage = uiImage
                                }
                            }
                    }
                }
            }
        }
    }
    
    private func removeLogs(from indexSet: IndexSet) {
        for index in indexSet {
            let log = logs[index]
            removeLog(log)
        }
    }
    
    private func removeLog(_ log: MLog) {
        modelContext.delete(log)
    }
}

#Preview {
    let previewContainer = try! ModelContainer(for: MLog.self)
    return ContentView()
        .modelContainer(previewContainer)
}
