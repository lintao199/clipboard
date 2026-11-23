<p align="center">
    <div align="center"><img src=Clipboard/Resource/Assets.xcassets/AppIcon.appiconset/icon-256.png width=135  /></div>
    <h2 align="center">Clipboard</h2>
    <div align="center">A macOS clipboard manager that helps you manage and use your clipboard history more efficiently.
</div>
    <div align="center"><strong>English</strong> | <a href="https://github.com/Ineffable919/clipboard/blob/master/README_ZH.md">中文</a></div>
</p>
<img src="examples.png">

## Local build

This fork removes upstream automatic updates, manual update checks, and the Sparkle dependency. Open `Clipboard.xcodeproj` in the full Xcode application and build the Release configuration. To update, review the source changes and rebuild locally.

Link previews and remote images in Markdown previews retain their existing network behavior.

Apple Silicon Release build (run from the repository root with Xcode selected):

```sh
xcodebuild -project Clipboard.xcodeproj -scheme Clipboard \
  -configuration Release -destination 'platform=macOS,arch=arm64' \
  -derivedDataPath build -clonedSourcePackagesDirPath build/SourcePackages \
  CODE_SIGN_STYLE=Manual CODE_SIGN_IDENTITY=- DEVELOPMENT_TEAM= \
  CODE_SIGN_INJECT_BASE_ENTITLEMENTS=NO build
```

The app is written to `build/Build/Products/Release/Clipboard.app`. This command uses a local signature and disables automatic injection of debugger permissions.


## Features

- **Real-time Clipboard Monitoring**: Automatically captures and saves text, images, and files you copy
- **Smart Categorization**: Automatically organizes content by text, images, and file types
- **History Records**: Saves your clipboard history for easy access anytime
- **Customizable Settings**: Supports custom categories and configurable history retention periods
- **Quick Search**: Quickly find history records using keywords
- **Intuitive Interface**: Modern card-based UI design with simple and intuitive operations, supports both light and dark modes
- **Quick Operations**:
  - Double-click to paste directly
  - Shift + mouse scroll
  - Spacebar to preview content
  - Keyboard navigation support
  - Right-click menu for more options
- **Safe Deletion**: Confirmation required to avoid accidental deletions
- **Drag & Drop Support**: Drag content to other applications

## System Requirements

- macOS 14.0 or later (Compatible with macOS 26，27)
- Supports Apple Silicon (arm64) and Intel (x86_64) architectures

## How to Use

1. Copy any content normally (text, images, or files)
2. Open the Clipboard app to view history
3. Interact with history records using:
   - Double-click an item to paste directly
   - Single-click to select, then press Enter to paste
   - Press Spacebar to preview content
   - Use left/right arrow keys to navigate
   - Right-click an item to open context menu for more actions

## Keyboard Shortcuts

- `ESC`: Close the app window
- `← →`: Navigate between history records
- `Space`: Preview selected item
- `↩`: Paste selected item
- `Shift + ⏎`: Paste as plain text
- `⌘ + C`: Copy selected item to clipboard
- `Delete`: Delete selected item

## FAQ

### App won't open?

1. Check System Settings -> Privacy & Security -> Allow applications from the following sources.
2. Try the following commands:
``` sh
sudo xattr -r -d com.apple.quarantine /Applications/Clipboard.app 
sudo codesign --force --deep --sign - /Applications/Clipboard.app
```

## License

This project is licensed under the [PolyForm Noncommercial License 1.0.0](https://polyformproject.org/licenses/noncommercial/1.0.0). See the [LICENSE](LICENSE) file for details.

- Commercial use is **not** allowed.
- Forks, modifications and redistributions must keep the `Required Notice:` line in [LICENSE](LICENSE) (copyright and original repository: https://github.com/Ineffable919/clipboard) and include a copy of the license or its URL.
