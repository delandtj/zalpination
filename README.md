# Zalpination

Zalpination is a project to adapt an Alpine Linux minirootfs to use [zinit](https://github.com/threefoldtech/zinit) as PID 1 instead of OpenRC.

## What is zinit?

Zinit is a lightweight init system and service manager written in Rust. It's designed to be simple, lightweight, and reliable for both system services and container environments. It's inspired by runit but uses Tokio for async I/O.

## Project Structure

- `alpine-zinit/`: Contains the Alpine minirootfs and the modified rootfs
- `scripts/`: Contains scripts for building zinit and adapting the Alpine minirootfs
- `configs/`: Contains configuration files for zinit services

## Dependencies

- Git
- Rust/Cargo (1.46.0 or later recommended)
- Make
- musl and musl-tools (for building statically linked binaries)
- systemd-nspawn (optional, for running the container)

You can check if all required dependencies are installed by running:
```
./scripts/check_dependencies.sh
```

## Usage

**Note: Most scripts need to be run as root (sudo) because they modify system files in the rootfs.**

1. Check the status of the project:
   ```
   sudo ./scripts/status.sh
   ```
   This will show the current status of the project, including what components are installed and what steps have been completed.

2. Run the main script to build zinit and adapt the Alpine minirootfs:
   ```
   sudo ./scripts/create_alpine_zinit.sh
   ```
   
   This script will:
   - Check if all required dependencies are installed
   - Download and extract the Alpine minirootfs if it doesn't exist
   - Build zinit from source
   - Install zinit in the rootfs and configure it

3. Test zinit in the modified rootfs:
   ```
   sudo ./scripts/test_zinit.sh
   ```

4. Run the modified rootfs in a container (requires systemd-nspawn):
   ```
   sudo ./scripts/run_container.sh
   ```

5. Clean up the project (optional):
   ```
   ./scripts/cleanup.sh
   ```
   This will remove the work directory and zinit binary, but will NOT remove the Alpine minirootfs or the modified rootfs.

6. Reset the rootfs to its original state (optional):
   ```
   sudo ./scripts/reset_rootfs.sh
   ```
   This will reset the rootfs to its original state (without zinit). All changes made to the rootfs will be lost.

7. Create a tarball of the modified rootfs (optional):
   ```
   sudo ./scripts/create_tarball.sh
   ```
   This will create a tarball of the modified rootfs in the `output` directory.

8. Create a Docker image from the modified rootfs (optional):
   ```
   sudo ./scripts/create_docker_image.sh
   ```
   This will create a Docker image named `alpine-zinit` from the modified rootfs.
   You can run it using: `docker run -it --device=/dev/kmsg:/dev/kmsg:rw alpine-zinit`

4. The modified rootfs will be available at:
   ```
   alpine-zinit/rootfs/
   ```

## Scripts

- `scripts/check_dependencies.sh`: Checks if all required dependencies are installed
- `scripts/download_alpine.sh`: Downloads and extracts the Alpine minirootfs if it doesn't exist
- `scripts/build_zinit.sh`: Builds zinit from source
- `scripts/install_zinit.sh`: Installs zinit in the rootfs and configures it
- `scripts/create_alpine_zinit.sh`: Orchestrates the entire process
- `scripts/test_zinit.sh`: Tests zinit in the modified rootfs using chroot (requires root)
- `scripts/run_container.sh`: Runs the modified rootfs in a container using systemd-nspawn (requires root)
- `scripts/cleanup.sh`: Cleans up the project by removing the work directory and zinit binary
- `scripts/reset_rootfs.sh`: Resets the rootfs to its original state (without zinit)
- `scripts/create_tarball.sh`: Creates a tarball of the modified rootfs
- `scripts/create_docker_image.sh`: Creates a Docker image from the modified rootfs
- `scripts/status.sh`: Checks the status of the project
- `scripts/save_context.sh`: Saves the current context of the project to a file

## Service Configurations

The following services are configured by default:

- `mdev`: Device manager
- `syslogd`: System logging daemon
- `networking`: Network configuration
- `dropbear`: SSH server

## License

This project is licensed under the MIT License - see the LICENSE file for details.