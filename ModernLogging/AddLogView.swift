//
//  AddLogView.swift
//  ModernLogging
//
//  Created by Sucu, Ege on 13.11.2024.
//

import SwiftUI
import PhotosUI
import OSLog
import UIKit
import SwiftData

struct AddLogView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @State private var log = MLog(mood: .content, date: .now)
    @State private var content = ""
    @State private var mood: Mood = .happy
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var photos: [UIImage] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    moodView
                    contentView
                    dailyPhotoDumpView
                    saveButton
                        .padding(.all)
                }
            }
            .navigationTitle(
                Text("Add New Log")
                    .accessibilityLabel(
                        AccessibilityIdentifiers.addLogView
                    )
            )
        }
    }
    
    var moodView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("What defines you best?")
                    .bold()
                    .font(.headline)
                    .foregroundStyle(Color.gray)
                Picker("Mood", selection: $mood) {
                    ForEach(Mood.allCases) { selection in
                        Text(selection.rawValue.capitalized)
                            .fontWeight(.black)
                    }
                }
                .tint(Color.black.opacity(0.7))
                .accessibilityIdentifier(
                    AccessibilityIdentifiers.addLogPicker
                )
            }
        }
        .padding()
    }
    
    var contentView: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Content")
                        .bold()
                        .font(.headline)
                        .foregroundStyle(Color.gray)
                    TextEditor(
                        text: $content
                    )
                    .overlay {
                        if content.isEmpty {
                            Text("What do you want to write?")
                                .bold()
                                .font(.callout)
                                .foregroundStyle(Color.gray)
                        }
                    }
                    .background(roundedBackground)
                    .frame(minHeight: 250)
                    
                }
                .padding(.all)
            }
        }
    }
    
    var roundedBackground: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.clear)
            .stroke(
                Color.gray,
                style: .init(
                    lineWidth: 1.2,
                    dash: [5, 5]
                )
            )
    }
    
    var dailyPhotoDumpView: some View {
        VStack {
            HStack {
                Text("Dump some photos for today.")
                    .font(.headline)
                    .foregroundStyle(Color.gray)
                    .padding(.all)
                PhotosPicker(
                    selection: $selectedItems,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Image(systemName: "plus.circle.dashed")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 30))
                        .foregroundColor(.gray)
                }
                .buttonStyle(.borderless)
            }
            .onChange(of: selectedItems) {
                Task {
                    await loadImages()
                }
            }
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(photos, id: \.self) { photo in
                        Image(uiImage: photo)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                            .padding(.all)
                    }
                }
            }
        }
    }
    
    var saveButton: some View {
        HStack {
            Spacer()
            Button(action: save) {
                Text("Save")
                    .font(.title)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.blue.mix(with: .black, by: 0.4))
            Spacer()
        }
    }
    
    private func save() {
        log = MLog(
            mood: mood,
            date: .now,
            images: map(photos),
            notes: content
        )
        
        context.insert(log)
        dismiss.callAsFunction()
        
    }
    
    private func loadImages() async {
        photos.removeAll()
        for item in selectedItems {
            if let data = try? await item.loadTransferable(type: Data.self),
               let photo = UIImage(data: data) {
                photos.append(photo)
            } else {
                Logger().error("Could not load image \(item.itemIdentifier ?? "")")
            }
        }
    }
    
    private func map(_ photos: [UIImage]) -> [Data?] {
        photos.map { $0.jpegData(compressionQuality: 0.8) }
    }
}

#Preview {
    let previewContainer = try! ModelContainer(for: MLog.self)
    return AddLogView()
        .modelContainer(previewContainer)
}
