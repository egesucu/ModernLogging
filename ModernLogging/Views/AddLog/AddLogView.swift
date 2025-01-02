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

    @State private var viewModel: AddLogViewModel

    init(viewModel: AddLogViewModel) {
        self.viewModel = viewModel
    }

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
                Picker("Mood", selection: $viewModel.mood) {
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
                        text: $viewModel.content
                    )
                    .overlay {
                        if viewModel.content.isEmpty {
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
                    selection: $viewModel.selectedItems,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Image(systemName: "plus.circle.dashed")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 30))
                        .foregroundColor(.gray)
                }
                .buttonStyle(.borderless)
                .accessibilityIdentifier("Add Photo Button")
            }
            .onChange(of: viewModel.selectedItems) {
                Task {
                    await loadImages()
                }
            }
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(viewModel.photos, id: \.self) { photo in
                        Image(uiImage: photo)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                            .padding(.all)
                    }
                }
            }
            .accessibilityIdentifier("Photo Scroll")
        }
    }

    var saveButton: some View {
        HStack {
            Spacer()
            Button {
                viewModel.save(context: context)
                dismiss.callAsFunction()
            } label: {
                Text("Save")
                    .font(.title)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.blue.mix(with: .black, by: 0.4))
            Spacer()
        }
    }

    func loadImages() async {
        viewModel.photos.removeAll()
        for item in viewModel.selectedItems {
            if let data = try? await item.loadTransferable(type: Data.self),
               let photo = UIImage(data: data) {
                viewModel.photos.append(photo)
            } else {
                Logger().error("Could not load image \(item.itemIdentifier ?? "")")
            }
        }
    }
}
// swiftlint: disable force_try
#Preview {
    let previewContainer = try! ModelContainer(for: MLog.self)
    return AddLogView(
        viewModel: .init()
    )
        .modelContainer(previewContainer)
}
// swiftlint: enable force_try
