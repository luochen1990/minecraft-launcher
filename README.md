Minecraft Launcher
==================

使用说明
--------

启动服务器

```sh
./scripts/server-launcher
```

启动客户端

```sh
./scripts/client-launcher
```

更新 mod 版本

```sh
./scripts/update-mods
```

选择 Minecraft 版本 及 增删 Mod

```sh
vi config.json
```

其中 Mod 可以在以下地址寻找:

- https://modrinth.com/mods
- https://www.curseforge.com/minecraft/mc-mods

找到想要添加的 Mod 后，将其 URL 添加到 `config.json`, 然后运行 `update-mods` 即可.

问题排查
--------

1. 如果遇到无法登录，可以尝试删除 `~/.local/share/minecraft.nix/profile.json` 文件后重试.

