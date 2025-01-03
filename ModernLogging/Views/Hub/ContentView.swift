//
//  ContentView.swift
//  ModernLogging
//
//  Created by Sucu, Ege on 6.11.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @Query(sort: \MLog.date, order: .reverse) var logs: [MLog]
    @Environment(\.modelContext) var modelContext
    @State var contentViewModel = ContentViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                dataOfDayView()
                    .padding()
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
                            HStack {
                                Text("Date")
                                    .bold()
                                Spacer()
                                Text(log.date.formatted())
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
            }
            .navigationTitle("Logs")
            .toolbar {
                ToolbarItem {
                    Button {
                        contentViewModel.openAddLog.toggle()
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
            isPresented: $contentViewModel.openAddLog
        ) {
            AddLogView(viewModel: .init())
        }
        .overlay(content: previewImageOverlay)
        .task {
            await contentViewModel.fetchData()
        }
    }

    @ViewBuilder
    func previewImageOverlay() -> some View {
        if let image = contentViewModel.selectedImage {
            ZStack {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        contentViewModel.selectedImage = nil
                    }
                Image(uiImage: image)
                    .resizable()
                    .clipShape(.rect(cornerRadius: 10))
                    .frame(width: 250, height: 250)
            }
            .animation(.smooth, value: contentViewModel.selectedImage)
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
                                    contentViewModel.selectedImage = uiImage
                                }
                            }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func dataOfDayView() -> some View {
        if let dataOfDay = contentViewModel.dataOfDay {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(dataOfDay.title)
                        .bold()
                        .font(.title)
                    Spacer()
                    Button {
                        Task { @MainActor in
                            await contentViewModel.fetchData()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                Text(dataOfDay.content)
                    .font(.callout)
                    .animation(.interpolatingSpring, value: dataOfDay.content)
            }
            .padding()
            .background(
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .clipShape(.rect(cornerRadius: 20))
                    .animation(.smooth, value: dataOfDay.content)
            )
        } else {
            Text("No Data")
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
// swiftlint: disable force_try
#Preview {
    let previewContainer = try! ModelContainer(for: MLog.self)

    let contentViewModel = ContentViewModel()
    Task {
        await contentViewModel.fetchData()
    }

    return ContentView(contentViewModel: contentViewModel)
        .modelContainer(previewContainer)
}
// swiftlint: enable force_try
