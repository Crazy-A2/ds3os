![Dark Souls 3 - Open Server](./Resources/banner.png?raw=true)

![GitHub license](https://img.shields.io/github/license/TLeonardUK/ds3os)

中文版: [README.md](README.md)

# What is DSOS?
DSOS is an open-source implementation of the game servers for Dark Souls 3 and Dark Souls 2: Scholar of the First Sin (SOTFS).

This project aims to provide a more isolated online environment — letting players use mods with a lower risk of bans, or play privately with friends without dealing with cheaters, invasions, and other problems common in public lobbies.

If you run into issues, join the Discord for technical support:
https://discord.gg/pBmquc9Jkj

# Component Overview
The repository is made up of the following major parts:

- `Loader`: Windows GUI launcher that fetches server lists, starts the game, and connects to custom servers
- `Injector`: Windows-only module injected into the game to redirect its online target
- `Server`: Main server program handling login, authentication, gameplay logic, and the WebUI
<!-- - `MasterServer`: Node.js API service for publishing and listing active servers -->
- `WebUI`: Static assets for the server management page, distributed alongside the server

If this is your first time here, the short version is:

1. Players use `Loader` to join servers
2. Hosts run `Server.exe` to run their own server
<!-- 3. `MasterServer` is only relevant when maintaining a fork or a public server list -->

# Can it be used with a pirated copy?
Not yet, due to checks inherited from the upstream repository. I plan to remove those checks later.

# How do I use it?
After building, outputs are organized by platform, architecture, and mode, for example:

- `bin/x64_release/`
- `bin/x64_debug/`
- `bin/x86_release/`

On a typical Windows x64 workflow, `xmake build-server` and `xmake build-all` also produce:

- `bin/<arch>_<mode>/Loader/`
- `bin/<arch>_<mode>/Server/`

The two parts you will use most are `Loader/` and `Server/`.

- `Loader`: starts the game and connects it to a custom server
- `Server`: runs your own dedicated server

## Player Quick Start
1. Get the launcher from the `Loader` directory.
2. Run Loader as administrator.
3. Select the game in Loader, refresh the server list, and join your target server.
4. If the server has a password, enter it before connecting.

## Host Quick Start
1. Run `Server.exe` from the `Server` directory.
2. On first launch it generates `Saved/default/config.json`.
3. Edit the config and restart the server to apply changes.
4. For public internet access, also configure port forwarding, firewall rules, and your WAN/LAN addresses.

To enable password protection, set a password in `Saved/default/config.json`. Players will then be prompted for it before connecting.

**Note:** The **Steam client** must be installed on the host machine when running `Server.exe` (login is not required). Without it, `Server.exe` may fail to initialize.

# Current Support Status
Most core functionality works, though behavior may still differ from official servers in some areas. The project is actively being improved to better match retail server behavior and overall usability.

**Note:** Dark Souls 2: Scholar of the First Sin support is still experimental and more likely to exhibit unexpected behavior.

| Feature | Dark Souls 3 | Dark Souls 2 |
| --- | --- | --- |
| Basically usable | :heavy_check_mark: | Experimental |
| Network transport | :heavy_check_mark: | :heavy_check_mark: |
| Announcement messages | :heavy_check_mark: | :heavy_check_mark: |
| Profile management | :heavy_check_mark: | :heavy_check_mark: |
| Blood messages | :heavy_check_mark: | :heavy_check_mark: |
| Bloodstains | :heavy_check_mark: | :heavy_check_mark: |
| Ghosts | :heavy_check_mark: | :heavy_check_mark: |
| Summoning | :heavy_check_mark: | :heavy_check_mark: |
| Invasions | :heavy_check_mark: | :heavy_check_mark: |
| Auto-summoning (covenants) | :heavy_check_mark: | :heavy_check_mark: |
| Mirror Knight | n/a | :heavy_check_mark: |
| Matchmaking | :heavy_check_mark: | :heavy_check_mark: |
| Leaderboards | :heavy_check_mark: | :heavy_check_mark: |
| Bell ringing | :heavy_check_mark: | n/a |
| Quick matches (arena) | :heavy_check_mark: | :heavy_check_mark: |
| Telemetry / misc | :heavy_check_mark: | :heavy_check_mark: |
| Steam ticket authentication | :heavy_check_mark: | :heavy_check_mark: |
| Master Server support | :heavy_check_mark: | :heavy_check_mark: |
| Loader support | :heavy_check_mark: | :heavy_check_mark: |
| Admin WebUI | :heavy_check_mark: | :heavy_check_mark: |
| Sharding support | :heavy_check_mark: | :heavy_check_mark: |
| Discord activity feed | :heavy_check_mark: |  |

## Roadmap

- Per-server mod options (e.g. removing summon count limits)
- Improved anti-cheat capabilities

# Will this get my retail account banned?
DSOS uses separate save files.

As long as you **do not copy DSOS saves back into your retail saves**, you should be fine.

# FAQ
## How do I switch between Dark Souls 3 and Dark Souls 2?
After the server runs for the first time it creates `Saved/default/config.json`.

Change the `GameType` field between `DarkSouls2` and `DarkSouls3` to select which game the server hosts.

## Why can't I see my saves?
DSOS keeps its own separate save files to avoid touching your retail saves.

To import retail saves into DSOS, click the settings (gear) icon at the bottom of Loader and use the "Copy retail saves" option.

For safety reasons, the project **does not provide** an automated way to copy DSOS saves back into retail saves.

If you **really know what you are doing**, you can manually locate the save directory and rename `.ds3os` files to `.sl2`.

## The game starts but cannot connect to the server. What should I check?
There are a few common causes.

First, make sure Loader is running **as administrator**. The launcher patches game memory to redirect it to the custom server, which typically requires admin privileges.

If you are hosting the server yourself and that does not help, also check:

1. Your router forwards these ports for both TCP and UDP: `50000`, `50010`, `50050`, `50020`
2. Windows Defender Firewall allows the server executable
3. The network fields in `Saved/config.json` are correct

The most important fields are:

- `ServerHostname`: your public/WAN IP
- `ServerPrivateHostname`: your LAN IP

If you are using LAN simulation software such as Hamachi, set these to the corresponding virtual LAN IPs.

## What do the fields in the config file mean?
Field documentation is maintained in the source code here:
https://github.com/Crazy-A2/ds3os/blob/main/Source/Server/Config/RuntimeConfig.h

Common fields at a glance:

| Field | Description |
| --- | --- |
| `GameType` | Server game type: `DarkSouls3` or `DarkSouls2` |
| `ServerHostname` | Public/WAN IP for internet players |
| `ServerPrivateHostname` | LAN IP for local players |
| `Password` | Server password; leave empty for no password |
| `Advertise` | Whether to publish this server to MasterServer |
| `ServerName` | Display name of the server |
| `Announcement` | Text shown to players when they join |

# How do I build it?
This fork focuses on a **Windows + XMake** workflow. The build entry point is `xmake.lua` in the repository root.

## Requirements
- [Visual Studio BuildTools](https://aka.ms/vs/stable/vs_BuildTools.exe) or [Visual Studio](https://visualstudio.microsoft.com/vs/)
- Windows SDK
- [.NET 10 SDK](https://dotnet.microsoft.com/download) (required only when building Loader)
- [XMake](https://xmake.io/guide/quick-start.html)

## Build Steps

### 1. Configure the build environment
Run this once before your first build:

```bash
xmake config --plat=windows --arch=x64 --mode=release --toolchain=msvc
```

### 2. One-command build (recommended)
```bash
xmake build-all
```

This runs in sequence: configure MSVC → build Server → build Injector → build Loader → organize output → copy runtime assets.

### 3. Build individual parts
If you only need a specific component:

```bash
# Build server (on Windows x64, also builds Injector and Loader)
xmake build-server

# Build Loader only (Windows x64 only)
xmake build-loader

# Build Server executable only
xmake build Server

# Build Injector DLL only
xmake build Injector
```

### 4. Copy runtime assets
To copy WebUI, Steam runtime libraries, and other assets into the output directories without recompiling:

```bash
xmake install-all
```

## Common XMake Tasks

| Command | What it does |
| --- | --- |
| `xmake build-all` | Calls `build-server`, then `install-all` |
| `xmake build-server` | Builds Server; on Windows x64 also builds Injector and Loader, then organizes output |
| `xmake build-loader` | Windows x64 only; builds Injector and Loader |
| `xmake install-all` | Copies `Source/WebUI`, Steam runtime libs, and dynamic libs from `lib/` to output dirs |
| `xmake clean-bin-libs` | Removes `.lib` / `.pdb` files under `bin/` |

## Output Directory Layout
Build artifacts go to `bin/<arch>_<mode>/` by default:

```text
bin/
├── x64_release/
│   ├── Server/        ← Server.exe, WebUI, steam_api64.dll, etc.
│   └── Loader/        ← Loader.exe, Injector.dll, etc.
├── x64_debug/
└── x86_release/
```

The `Server/` directory also contains static assets from `Source/WebUI`. The server serves the WebUI directly from there after startup.

## OpenSSL Notes
Prebuilt OpenSSL libraries from `lib/` are linked by default. To build OpenSSL from source instead, add:

```bash
xmake config ... --bundled_openssl=y
```

## MasterServer (optional)
MasterServer is a standalone Node.js service. You only need it if you want to maintain your own server list.

```bash
cd Source/MasterServer
npm install
npm run start        # production mode
npm run start:dev    # development mode (nodemon auto-restart)
```

A Docker image is also available (see Docker notes below).

# Repository Layout
```text
/
├── xmake.lua              Build entry; defines all C++ targets
├── plugins/               Custom XMake tasks (build-all, build-server, etc.)
├── Protobuf/              Protobuf definitions for server network communication
├── Resources/             Shared build/package resources (icons, documents, etc.)
├── Source/                All project source code
│   ├── Injector/          DLL injected into the game (Windows only) to redirect online target
│   ├── Loader/            WinForms launcher (Windows x64 only, .NET 10)
│   ├── MasterServer/      Server registry, Node.js API service
│   ├── Server/            Main server framework (login, auth, gameplay logic, WebUI)
│   ├── Server.DarkSouls3/ Dark Souls 3 specific implementation
│   ├── Server.DarkSouls2/ Dark Souls 2 specific implementation (experimental)
│   ├── Shared/            Core library shared by server and injector
│   ├── ThirdParty/        Third-party source libraries (openssl, curl, sqlite, protobuf, etc.)
│   └── WebUI/             Static assets for the server management page, distributed with Server
├── Tools/                 Helper scripts (VS project generation, protobuf, packaging, etc.)
└── lib/                   Prebuilt OpenSSL libraries (default linking method)
```

# How can I contribute?
Check the Issues page or reach out to the maintainers to find out where help is most needed.

High-value areas right now:

- Completing server calls that are still stubbed out or only return placeholder data
- Reverse-engineering the correct response formats for those interfaces
- Identifying the meaning of more unknown protobuf fields

All of these directly improve the completeness of the server implementation.

# Credits
This project would not be possible without the extensive research accumulated by the community over the years.

Special thanks to members of the Souls Modding community for their information and assistance.

The following repositories provided valuable reference material:

- https://github.com/garyttierney/ds3-open-re
- https://github.com/Jellybaby34/DkS3-Server-Emulator-Rust-Edition
- https://github.com/AmirBohd/ModEngine2

Graphics and icons:

- Campfire icon: ultimatearm (www.flaticon.com)
- Some UI icons: Mark James (http://www.famfamfam.com/lab/icons/silk/)
