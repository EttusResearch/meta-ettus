SRC_URI = "git://github.com/EttusResearch/uhd.git;branch=UHD-3.15.LTS"
SRCREV = "aea0e2de34803d5ea8f25d7cf2fb08f4ab9d43f0"

# A note on PR and PV:
# PV is the package version, and PR is the package revision from the OE
# perspective. So if we need to modify meta-ettus to fix a version of UHD, but
# UHD itself is not changing, then we start incrementing the revision. We can
# leave out PR otherwise, but we can't retroactively take out PR because that
# would look like we're going back on the version numbers.
# General guidelines:
# - The first time we release a UHD + OE version, we put the version number into
#   PV, and remove PR if it's set.
# - Pre-releases to that use the `+foo` notation to append something to the
#   version number, such as `+rc1` or `+git5`.
# - If we need to modify the OE package info after tagging a UHD release, and
#   we've already published a version within OE, we start incrementing PR as in
#   r1, r2, etc.

PV = "3.15.0.0"
#PR = "r1"
