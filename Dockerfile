# Build a gentoo stage3 / amd64
FROM ghcr.io/xavierforestier/gentoo-ci-ha:main AS gentoo
ENV JOB_COUNT=16

RUN FEATURES='-usersandbox' emerge --jobs=${JOB_COUNT} --jobs-tmpdir-require-free-gb=0 -q --autounmask=y --autounmask-continue=y --autounmask-write=y --autounmask-license=y --autounmask-backtrack=y --autounmask-use=y --autounmask-keep-masks=n --autounmask-keep-keywords=n sci-ml/pytorch sci-ml/tokenizers sci-ml/transformers sci-ml/huggingface_hub
RUN FEATURES='-usersandbox' emerge -tNDuq --jobs=${JOB_COUNT} --jobs-tmpdir-require-free-gb=0 @world
# Cleanup
RUN emerge -C sys-apps/man-pages virtual/man 
RUN emerge -t --depclean && rm -rf /var/cache/distfiles/* /var/log/*.log && wget "https://www.gentoo.org/dtd/metadata.dtd" -O /var/cache/distfiles/metadata.dtd
FROM scratch
COPY --from=gentoo / /
