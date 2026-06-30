# installplz

`installplz` is a tiny Bash CLI for installing common Linux installer files with one command.

## Install

```bash
git clone https://github.com/egy2015/installplz.git
cd installplz
chmod +x install.sh
./install.sh
```

## Usage

```bash
installplz app.deb
installplz app.rpm
installplz app.pkg.tar.zst
installplz app.AppImage
installplz installer.sh
installplz source.tar.gz
installplz source.tgz
installplz source.tar.xz
installplz source.zip
```

Supported file types: `.deb`, `.rpm`, `.pkg.tar.zst`, `.AppImage`, `.sh`, `.run`, `.bin`, `.tar.gz`, `.tgz`, `.tar.xz`, `.tar.bz2`, and `.zip`.

Native packages are checked against `/etc/os-release` before installation: APT for Debian-based systems, DNF/YUM/Zypper for RPM-based systems, and Pacman for Arch Linux. A mismatched package stops with an error instead of forcing installation.

For archives, `installplz` extracts into a new folder and looks for these installers in order:

1. `install.sh`
2. `configure` (`make`, then `sudo make install`)
3. `CMakeLists.txt` (`cmake`, `make`, then `sudo make install`)
4. `meson.build` (`meson setup build`, compile, then install)
5. `Makefile` or `makefile` (`make`, then `sudo make install`)
6. `package.json` (`npm install`)
7. `Cargo.toml` (`cargo install --path .`)
8. `DEBS/*.deb` or `RPMS/*.rpm` package bundles

If extraction or installation fails, `installplz` prints the extraction path and any nearby `README*`, `INSTALL*`, or `docs/` entries. It keeps the files by default and deletes them only when you type exactly `yes`.

## Security

Always inspect `.sh`, `.run`, and `.bin` files before running them. `installplz` asks for confirmation, but these files can execute arbitrary commands with your user permissions.

## Uninstall

```bash
chmod +x uninstall.sh
./uninstall.sh
```

Uninstalling backs up `.bashrc`, removes only the block marked by `installplz`, and prints the backup path.

## Limitations

- Linux and Bash only; shell configuration is limited to `~/.bashrc`.
- Native package support is limited to Debian-based, RPM-based, and Arch Linux distributions.
- Archive installation depends on the tools required by the detected project, such as `make`, `cmake`, `meson`, `npm`, or `cargo`.
- Installers inside archives must be at the archive root or its single top-level directory.

## License

MIT
