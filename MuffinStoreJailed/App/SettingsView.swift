//
//  SettingsView.swift
//  PancakeStore
//
//  Created by Main on 1/11/26.
//

import SwiftUI
import PartyUI

struct SettingsView: View {
    @EnvironmentObject var appData: AppData
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    
    @AppStorage("autoCleanApp") var autoCleanApp: Bool = true
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: HeaderLabel(text: "关于", icon: "info.circle")) {
                    VStack(alignment: .leading, spacing: 10) {
                        AppInfoCell()
                        HStack {
                            Button(action: {
                                openURL(URL(string: "https://jailbreak.party/discord")!)
                            }) {
                                ButtonLabel(text: "Discord", icon: "discord", useImage: true)
                            }
                            .buttonStyle(TranslucentButtonStyle(color: .discord))
                            Button(action: {
                                openURL(URL(string: "https://github.com/jailbreakdotparty/PancakeStore")!)
                            }) {
                                ButtonLabel(text: "GitHub", icon: "github", useImage: true)
                            }
                            .buttonStyle(TranslucentButtonStyle(color: .github))
                        }
                        Button(action: {
                            openURL(URL(string: "https://jailbreak.party/")!)
                        }) {
                            ButtonLabel(text: "网站", icon: "globe")
                        }
                        .buttonStyle(TranslucentButtonStyle())
                    }
                }
                
                Section(header: HeaderLabel(text: "设置", icon: "gearshape")) {
                    Toggle(isOn: $autoCleanApp) {
                        Text("自动清理应用")
                        Text("默认开启，以确保 PancakeStore 不会保留已降级应用的任何数据。")
                    }
                }
                
                Section(header: HeaderLabel(text: "数据", icon: "loupe"), footer: Text("如果 PancakeStore 占用大量存储空间，请点击此按钮。")) {
                    VStack {
                        Button(action: {
                            let tempDir = FileManager.default.temporaryDirectory
                            let tempIPAURL = tempDir.appendingPathComponent("app.ipa")
                            presentShareSheet(with: tempIPAURL)
                        }) {
                            ButtonLabel(text: "导出IPA", icon: "arrow.up.doc")
                        }
                        .buttonStyle(TranslucentButtonStyle())
                        .disabled(!appData.hasAppBeenServed)
                        Button(action: {
                            cleanUp()
                        }) {
                            ButtonLabel(text: "清理文档", icon: "trash")
                        }
                        .buttonStyle(TranslucentButtonStyle())
                    }
                }
                Section(header: HeaderLabel(text: "致谢", icon: "star")) {
                    LinkCreditCell(image: Image("mineek"), name: "mineek", description: "MuffinStore Jailed 的原作者。", url: "https://github.com/mineek")
                    LinkCreditCell(image: Image("lunginspector"), name: "lunginspector", description: "界面改进和体验优化。", url: "https://github.com/lunginspector")
                    LinkCreditCell(image: Image("skadz"), name: "Skadz", description: "两次修复了整个认证系统。", url: "https://github.com/skadz108")
                }
            }
            .navigationTitle("设置")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}