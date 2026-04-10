![Dark Souls 3 - Open Server](./Resources/banner.png?raw=true)

![GitHub license](https://img.shields.io/github/license/TLeonardUK/ds3os)
![GitHub release](https://img.shields.io/github/release/TLeonardUK/ds3os)
![GitHub downloads](https://img.shields.io/github/downloads/TLeonardUK/ds3os/total)
[![Discord](https://img.shields.io/discord/937318023495303188?label=Discord)](https://discord.gg/pBmquc9Jkj)

# What is DS3OS?
DS3OS is an open-source implementation of the game servers for Dark Souls 3 and Dark Souls 2: Scholar of the First Sin (SOTFS).

This project mainly exists to provide a more isolated online environment, allowing players to use mods with a lower risk of bans, or to play privately with friends without dealing with cheaters, invasions, and other issues common in public online play.

If you run into problems, you can join the Discord for technical support:
https://discord.gg/pBmquc9Jkj

# Can it be used with a pirated copy of the game?
No.

The server authenticates Steam tickets, so please do not ask about piracy, Steam emulators, or similar topics. This project does not support them.

If you can, please support FROM SOFTWARE's games as well.

# Where can I download it?
Releases are available here:
https://github.com/TLeonardUK/ds3os/releases

# How do I use it?
After building, you will usually get a `bin/` directory. The two most important parts are `Loader/` and `Server/`.

- `Loader`: used to start the game and connect it to a custom server
- `Server`: used to start your own dedicated server

After launching the Loader, you can choose to create a server or join an existing one.

If you want to host your own server, run `Server.exe` from the `Server` directory. This starts the actual DS3OS custom server on your machine.

When the server is started for the first time, it generates `Saved/default/config.json`. You can edit the matchmaking and server settings there, then restart the server to apply them.

If you want password protection, set a password in `Saved/default/config.json`. Players will then be required to enter that password before connecting.

**Note:** The **Steam client** must be installed on the machine when running `Server.exe` (login is not required). Otherwise, `Server.exe` may fail to initialize properly.

# Current support status
Most core functionality already works, although behavior may still differ from the official retail servers in some areas. The project is still being improved, with the goal of getting closer to retail server behavior and improving the usability of unofficial servers.

**Note:** Dark Souls 2: Scholar of the First Sin support is still experimental, and incorrect behavior is fairly likely.

| Feature | Dark Souls 3 | Dark Souls 2 SOTFS |
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

- Support per-server mod settings (for example, allowing a server to remove summon limits)
- Improve anti-cheat capabilities

# Will this get my retail account banned?
DS3OS uses separate save files.

As long as you **do not copy DS3OS saves back into your retail saves**, you should generally be fine.

# FAQ
## How do I switch between hosting Dark Souls 3 and Dark Souls 2?
After the server runs for the first time, it creates `Saved/default/config.json`.

You can change the `GameType` parameter between `DarkSouls2` and `DarkSouls3` to select which game the server hosts.

## Why are my save files not showing up?
DS3OS uses separate save files to avoid affecting your retail saves.

If you want to import your retail saves into DS3OS, click the settings (cog) icon at the bottom of the Loader and use the option to copy retail saves.

For safety reasons, the project **does not provide** an automated way to copy DS3OS saves back into retail saves.

If you **really know what you are doing**, you can manually find the save directory and rename `.ds3os` files to `.sl2`.

## Can I run the server with Docker?
Yes.

DS3OS currently provides two Docker images, both updated automatically when a new release is published:

- `timleonarduk/ds3os`: the main server image, which is what almost everyone wants
- `timleonarduk/ds3os-master`: the Master Server image, mainly useful if you are maintaining your own fork

If you want a quick one-liner to start the server, you can use this command. It mounts the `Saved` directory to `/opt/ds3os/Saved` on the host, making it easier to edit configuration files directly.

`sudo mkdir -p /opt/ds3os/Saved && sudo chown 1000:1000 /opt/ds3os/Saved && sudo docker run -d -m 2G --restart always --net host --mount type=bind,source=/opt/ds3os/Saved,target=/opt/ds3os/Saved timleonarduk/ds3os:latest`

## The game launches, but it cannot connect to the server. What should I check?
There are several common causes.

The first thing to verify is whether you are running the Loader **as administrator**. The launcher needs to patch the game's memory so it connects to the custom server, and that usually requires admin privileges.

If you are hosting the server yourself and that does not solve the problem, also check the following:

1. Make sure your router forwards these ports for both TCP and UDP: `50000`, `50010`, `50050`, `50020`
2. Make sure Windows Defender Firewall allows the server executable
3. Make sure the network-related values in `Saved/config.json` are correct

The most important values are:

- `ServerHostname`: should be your WAN/public IP
- `ServerPrivateHostname`: should be your LAN/private IP

If you are using LAN emulation software such as Hamachi, set those values to the corresponding virtual LAN IPs instead.

## What do the fields in the config file mean?
Most configuration field descriptions are currently maintained in the source code here:
https://github.com/TLeonardUK/ds3os/blob/main/Source/Server/Config/RuntimeConfig.h

# How do I build it?
This fork is currently focused on a **Windows + XMake** workflow and no longer follows the original project's CMake-based workflow.

If you just want to build and run it quickly, the XMake workflow below is the recommended path.

## Requirements
- Visual Studio 2026 or newer
- Windows SDK
- .NET 10 SDK (required for building Loader)
- XMake

## Quick start
### 1. Install XMake
You can follow the official XMake documentation or install it using your preferred package manager.

### 2. Configure the build
For a first build, it is recommended to run:

```bash
xmake config --plat=windows --arch=x64 --mode=release --toolchain=msvc
```

### 3. Build the project
Common commands:

```bash
# Build Loader
xmake build-loader

# Build the main server
xmake build Server

# Build Injector
xmake build Injector

# Build Server, Injector, and Loader, then organize the output
xmake build-all
```

### 4. Copy runtime files
If you want to collect the required runtime files into the output layout, run:

```bash
xmake install-all
```

## Common build variants
### Debug build
```bash
xmake config --plat=windows --arch=x64 --mode=debug --toolchain=msvc
xmake build Server
```

### Release build
```bash
xmake config --plat=windows --arch=x64 --mode=release --toolchain=msvc
xmake build Server
```

### 32-bit build
```bash
xmake config --plat=windows --arch=x86 --mode=release --toolchain=msvc
xmake build Server
```

## Common XMake tasks
| Command | Description |
| --- | --- |
| `xmake build-loader` | Build the C# Loader |
| `xmake build-all` | Build Server, Injector, and Loader, then organize the output |
| `xmake build-server` | Build Server, and on x64 also build Injector and Loader |
| `xmake install-all` | Copy runtime files |
| `xmake clean-bin-libs` | Remove generated `.lib` / `.pdb` files under `bin/` |

## Output directories
The default output directories look like this:

- `bin/x64_debug/`
- `bin/x64_release/`
- `bin/x86_debug/`
- `bin/x86_release/`

In addition, `xmake build-server` and `xmake build-all` also organize files into layouts such as:

- `bin/<arch>_<mode>/Server/`
- `bin/<arch>_<mode>/Loader/`

## Additional build notes
- `Server`, `Injector`, and `Loader` are the three main build targets
- `Loader` depends on the .NET SDK
- The main build entry point for this repository is the root `xmake.lua`

## nix
The original upstream README kept nix-related notes, but this fork is not primarily maintained around a nix workflow. If you are using this fork, prefer the XMake workflow above.

# Repository layout
```text
/
├── Protobuf/              Protobuf definitions used by server network communication
├── Resources/             General resources used for building and packaging, such as icons and documents
├── Source/                All project source code
│   ├── Injector/          DLL injected into the game to provide DS3OS functionality
│   ├── Loader/            WinForms application used to start the game and connect to a custom server
│   ├── MasterServer/      Node.js API service for publishing and listing active servers
│   ├── Server/            Main server source code
│   ├── Server.DarkSouls3/ Dark Souls 3 specific server implementation
│   ├── Server.DarkSouls2/ Dark Souls 2 specific server implementation
│   ├── Shared/            Code shared by the server and injector
│   ├── ThirdParty/        Third-party library sources
│   └── WebUI/             Static resources used by the server management page
├── Tools/                 Analysis scripts, batch files, and helper tools
```

# How can I contribute?
You can check the Issues page or contact the maintainers to find out which areas need help most.

Some especially valuable areas right now include:

- Finishing server calls that are still stubbed out or only return placeholder data
- Reverse engineering the proper data formats those interfaces should return
- Identifying the meaning of more protobuf fields that are still unknown

All of these would directly improve the completeness of the server implementation.

# Credits
This project would not be possible without a large amount of research accumulated by the community.

Special thanks to members of the Souls Modding community for providing information and help.

The following repositories also provided a lot of useful reference material:

- https://github.com/garyttierney/ds3-open-re
- https://github.com/Jellybaby34/DkS3-Server-Emulator-Rust-Edition
- https://github.com/AmirBohd/ModEngine2

Graphics and icons:

- Campfire icon by ultimatearm (www.flaticon.com)
- Some UI icons by Mark James (http://www.famfamfam.com/lab/icons/silk/)
