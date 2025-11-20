# MikroTik Cheat Sheets for reports of configurations

Repo with MikroTik cheat sheets and shell script to maintain them

## Usage

### Create new report

```bash
./report.sh -r ${PLACE_ROS_MAJOR_VERSION} -f ${PATH_TO_REPORT_IN_REPORTS_DIR}
```

#### Example:

```bash
./report.sh -r 7 -f "my_net/my_kernel_router_model.md"
```

### List of your reports

```bash
./report.sh -t
```

## Dir structure

- [`/data/`](./data/) - Data directory
- [`/doc/`](./doc/) - Docs directory
- [`/reports/`](./reports/) - Reports directory
- [`/ros-firmware/`](./ros-firmware) - RouterOS firmware directory (soft link into `/data/`)
- [`/templates`](./templates/) - RouterOS cheat sheets per major version
- [`/LICENSE`](./LICENSE) - License file
- [`/NOTICE`](./NOTICE) - License file
- [`/README.md`](./README.md) - Current file
- [`/report.sh`](./report.sh) - Main shell script

## Additional tools

### ADR

It's helpful for maintain decisions about this repo

[Table of ADR's content](./doc/adr/README.md)

### Pre-commit

It's helpful for being stuff here structured and up-to-date

### Semantic release

It's helpful for being stuff here versioned and up-to-date

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](./LICENSE) file for details.
