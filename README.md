# image-build-cilium-certgen

This repo builds a hardened image for the Cilium `certgen` component that
rke2 mirrors, from [github.com/cilium/certgen](https://github.com/cilium/certgen), packaged in a scratch image.

Binaries are compiled against [`rancher/hardened-build-base`](https://github.com/rancher/image-build-base),
which provides the latest supported Go toolchain (FIPS/BoringCrypto-enabled on amd64).

## Images produced

- `rancher/hardened-cilium-certgen`

## Building locally

```sh
make build-image              # build for the host architecture
make image-scan               # run Trivy against the built image(s)
```

The upstream version is controlled by the `TAG` variable in the [`Makefile`](./Makefile).
A `-buildYYYYMMDD` suffix (`BUILD_META`) is appended automatically and is required on
release tags.