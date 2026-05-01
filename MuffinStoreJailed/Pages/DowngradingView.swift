//
//  DowngradingView.swift
//  PancakeStore
//
//  Created by lunginspector on 2/24/26.
//

import SwiftUI
import PartyUI

/*
struct DowngradingView: View {
    @EnvironmentObject var appData: AppData
    
    var body: some View {
        Section(header: HeaderLabel(text: "App Info", icon: "info.circle")) {
            LabeledContent {
                if appData.appLink.isEmpty {
                    ProgressView()
                } else {
                    Text(appData.appLink)
                }
            } label: {
                HStack {
                    Image(systemName: "link")
                        .frame(width: 24, alignment: .center)
                    Text("App Store Link")
                }
            }
            .contextMenu {
                Button(action: {
                    UIPasteboard.general.string = appData.appLink
                }) {
                    Label("Copy Link", systemImage: "link")
                }
            }
            LabeledContent {
                if appData.appBundleID.isEmpty {
                    ProgressView()
                } else {
                    Text(appData.appBundleID)
                }
            } label: {
                HStack {
                    Image(systemName: "shippingbox")
                        .frame(width: 24, alignment: .center)
                    Text("App Bundle ID")
                }
            }
            LabeledContent {
                if appData.appVersion.isEmpty {
                    ProgressView()
                } else {
                    Text(appData.appVersion)
                }
            } label: {
                HStack {
                    Image(systemName: "arrow.down.app")
                        .frame(width: 24, alignment: .center)
                    Text("Target App Version")
                }
            }
        }
    }
}
*/
