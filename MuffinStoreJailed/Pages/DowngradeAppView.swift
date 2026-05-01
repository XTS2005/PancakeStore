//
//  DowngradeAppView.swift
//  PancakeStore
//
//  Created by lunginspector on 2/24/26.
//

import SwiftUI
import PartyUI

/*
struct DowngradeAppView: View {
    @EnvironmentObject var appData: AppData
    
    var body: some View {
        Section(header: HeaderLabel(text: "Downgrade App", icon: "arrow.down.app"), footer: Text("Created by [mineek](https://github.com/mineek/MuffinStoreJailed-Public), improved with love by [jailbreak.party](https://github.com/jailbreakdotparty). Use this tool at your own risk! App data may be lost, and other damage could occur.")) {
            HStack {
                TextField("Link to App Store App", text: $appData.appLink)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(GlassyTextFieldStyle())
                Button(action: {
                    Haptic.shared.play(.soft)
                    appData.appLink = UIPasteboard.general.string ?? ""
                }) {
                    Image(systemName: "doc.on.doc")
                }
                .buttonStyle(GlassyButtonStyle(useFullWidth: false))
            }
        }
    }
}
*/
