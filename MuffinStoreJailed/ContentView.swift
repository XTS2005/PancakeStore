//
//  ContentView.swift
//  MuffinStoreJailed
//
//  Created by Mineek on 26/12/2024.
//

import SwiftUI
import PartyUI

struct ContentView: View {
    @State private var hasShownWelcome: Bool = false
    @State private var showLogs: Bool = true
    @State private var showSettingsView: Bool = false
    
    @EnvironmentObject var appData: AppData
    
    var body: some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                NavigationSplitView(sidebar: {
                    List {
                        LogsSection
                        NavigationButtons()
                    }
                    .navigationTitle("PancakeStore")
                }) {
                    List {
                        if !appData.isAuthenticated {
                            LoginSection
                        } else {
                            if appData.isDowngrading {
                                AppInfoSection
                            } else {
                                InputAppSection
                            }
                        }
                    }
                }
            } else {
                NavigationStack {
                    List {
                        LogsSection
                        if !appData.isAuthenticated {
                            LoginSection
                        } else {
                            if appData.isDowngrading {
                                AppInfoSection
                            } else {
                                InputAppSection
                            }
                        }
                    }
                    .navigationTitle("PancakeStore")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Menu {
                                Button(action: {
                                    let tempDir = FileManager.default.temporaryDirectory
                                    let tempIPAURL = tempDir.appendingPathComponent("app.ipa")
                                    presentShareSheet(with: tempIPAURL)
                                }) {
                                    Label("导出IPA", systemImage: "arrow.up.doc")
                                }
                                .disabled(!appData.hasAppBeenServed)
                                Button(action: {
                                    Haptic.shared.play(.heavy)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        EncryptedKeychainWrapper.nuke()
                                        EncryptedKeychainWrapper.generateAndStoreKey()
                                        sleep(3)
                                        exitinator()
                                    }
                                }) {
                                    ButtonLabel(text: "登出", icon: "arrow.right")
                                }
                                .disabled(!appData.isAuthenticated)
                            } label : { Image(systemName: "line.horizontal.3") }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                showSettingsView.toggle()
                            }) {
                                Image(systemName: "gear")
                            }
                        }
                    }
                    .safeAreaInset(edge: .bottom) {
                        NavigationButtons()
                            .modifier(OverlayBackground())
                    }
                }
            }
        }
        .sheet(isPresented: $showSettingsView) {
            SettingsView()
        }
        .onAppear {
            appData.isAuthenticated = EncryptedKeychainWrapper.hasAuthInfo()
            print("Found \(appData.isAuthenticated ? "auth" : "no auth") info in keychain")
            if appData.isAuthenticated {
                appData.applicationStatus = "准备降级！"
                appData.applicationIcon = "checkmark.circle.fill"
                appData.applicationIconColor = .primary
                guard let authInfo = EncryptedKeychainWrapper.getAuthInfo() else {
                    print("Failed to get auth info from keychain, logging out")
                    appData.isAuthenticated = false
                    EncryptedKeychainWrapper.nuke()
                    EncryptedKeychainWrapper.generateAndStoreKey()
                    return
                }
                appData.appleId = authInfo["appleId"]! as! String
                appData.password = authInfo["password"]! as! String
                appData.ipaTool = IPATool(appleId: appData.appleId, password: appData.password)
                let ret = appData.ipaTool?.authenticate()
                print("Re-authenticated \(ret! ? "successfully" : "unsuccessfully")")
            } else {
                print("No auth info found in keychain, setting up by generating a key in SEP")
                EncryptedKeychainWrapper.generateAndStoreKey()
            }
        }
    }
    
    private var LogsSection: some View {
        Section(header: HeaderLabel(text: "日志", icon: "terminal"), footer: Text("最初由 [mineek](https://github.com/mineek) 创建，[jailbreak.party](https://github.com/jailbreakdotparty) 进行了体验优化与后端修复。")) {
            VStack {
                TerminalHeader(text: appData.applicationStatus, icon: appData.applicationIcon, color: appData.applicationIconColor)
                LogView()
                    .modifier(TerminalPlatter())
            }
        }
    }
    
    private var LoginSection: some View {
        Group {
            Section(header: HeaderLabel(text: "登录", icon: "icloud"), footer: Text("")) {
                VStack {
                    TextField("Apple ID", text: $appData.appleId)
                        .modifier(TextFieldBackground())
                        .disabled(appData.hasSent2FACode)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    
                    HStack {
                        if appData.showPassword {
                            TextField("密码", text: $appData.password)
                                .modifier(TextFieldBackground())
                                .disabled(appData.hasSent2FACode)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                        } else {
                            SecureField("密码", text: $appData.password)
                                .modifier(TextFieldBackground())
                                .disabled(appData.hasSent2FACode)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                        }
                        
                        Button(action: {
                            appData.showPassword.toggle()
                        }) {
                            Image(systemName: appData.showPassword ? "eye" : "eye.slash")
                                .frame(width: 22, height: 22, alignment: .center)
                        }
                        .buttonStyle(TranslucentButtonStyle(useFullWidth: false))
                    }
                }
            }
            
            if appData.hasSent2FACode {
                Section(header: HeaderLabel(text: "验证码", icon: "key")) {
                    TextField("双重认证", text: $appData.code)
                        .modifier(TextFieldBackground())
                        .keyboardType(.numberPad)
                }
            }
        }
    }
    
    private var InputAppSection: some View {
        Section(header: HeaderLabel(text: "降级应用", icon: "arrow.down.app"), footer: Text("要降级应用，该应用必须曾在你账户中购买过（当应用旁边有云朵图标时）。该应用当前也不能安装在你的设备上，但你可以将其卸载。")) {
            VStack {
                TextField("App Store应用链接", text: $appData.appLink)
                    .modifier(TextFieldBackground())
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
        }
    }
    
    private var AppInfoSection: some View {
        Section(header: HeaderLabel(text: "应用信息", icon: "info.circle")) {
            ItemInfoCell(label: "应用链接", icon: "link", text: appData.appLink)
            ItemInfoCell(label: "应用包名 ID", icon: "shippingbox", text: appData.appBundleID)
            ItemInfoCell(label: "目标应用版本", icon: "arrow.down.app", text: appData.appVersion)
        }
    }
}

struct ItemInfoCell: View {
    var label: String
    var icon: String
    var text: String
    
    var body: some View {
        LabeledContent {
            if text.isEmpty {
                ProgressView()
            } else {
                Text(text)
            }
        } label: {
            HStack {
                Image(systemName: icon)
                    .frame(width: 22, height: 22, alignment: .center)
                Text(label)
            }
        }
        .contextMenu {
            Button(action: {
                UIPasteboard.general.string = text
            }) {
                Label("复制值", systemImage: "character.cursor.ibeam")
            }
        }
    }
}

struct SidebarToggleModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .toolbar(removing: .sidebarToggle)
        } else {
            content
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppData())
}
