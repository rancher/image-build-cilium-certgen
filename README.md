# image-build-cilium-certgen

This repo builds a hardened image for the Cilium `certgen` component that
rke2 mirrors, from [github.com/cilium/certgen](https://github.com/cilium/certgen), packaged in a minimal
SLE BCI (`registry.suse.com/bci/bci-nano`) based image.

Statically-linked Go binary that generates Hubble/certificate material for Cilium.

Binaries are compiled against [`rancher/hardened-build-base`](https://github.com/rancher/image-build-base),
which provides the latest supported Go toolchain (FIPS/BoringCrypto-enabled on amd64).

## Images produced

- `rancher/hardened-cilium-certgen`

## Building locally

```sh
make build-image-all          # build for the host architecture
make image-scan               # run Trivy against the built image(s)
```

The upstream version is controlled by the `TAG` variable in the [`Makefile`](./Makefile).
A `-buildYYYYMMDD` suffix (`BUILD_META`) is appended automatically and is required on
release tags.

## Automated updates

[Updatecli](./updatecli) keeps the upstream version and the
`rancher/hardened-build-base` version current via daily PRs.

## CI

- **Build**: builds the image and runs a [Trivy](https://github.com/aquasecurity/trivy) scan
  (`CRITICAL,HIGH`) on every PR/push.
- **Release**: on a published GitHub release (or manual dispatch), builds multi-arch images
  and pushes them to the Rancher Prime registry (`registry.rancher.com/rancher/hardened-cilium-certgen`).
