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
