ARG GO_IMAGE=rancher/hardened-build-base:v1.26.6b1

FROM --platform=$BUILDPLATFORM rancher/mirrored-tonistiigi-xx:1.6.1 AS xx

FROM --platform=$BUILDPLATFORM ${GO_IMAGE} AS builder
COPY --from=xx / /
RUN apk add --no-cache file make git clang lld
ARG TARGETPLATFORM
RUN set -x && xx-apk --no-cache add musl-dev gcc lld

ARG PKG=github.com/cilium/certgen
ARG TAG
RUN git clone --depth=1 https://${PKG}.git $GOPATH/src/${PKG}
WORKDIR $GOPATH/src/${PKG}
RUN git fetch --all --tags --prune
RUN git checkout tags/${TAG} -b ${TAG}
COPY go-mod-overrides ./go-mod-overrides
RUN go-mod-overrides.sh ./go-mod-overrides
RUN go mod download
ARG TARGETARCH
RUN xx-go --wrap && \
    go-build-static.sh -mod=vendor -tags osusergo,netgo -gcflags=-trimpath=${GOPATH}/src \
        -o "/usr/local/bin/cilium-certgen" .
RUN xx-verify --static /usr/local/bin/cilium-certgen
RUN if [ "$(xx-info arch)" = "amd64" ]; then \
        go-assert-boring.sh /usr/local/bin/cilium-certgen; \
    fi

FROM scratch AS hardened-cilium-certgen
COPY --from=builder /usr/local/bin/cilium-certgen /usr/bin/cilium-certgen
ENTRYPOINT ["/usr/bin/cilium-certgen"]
