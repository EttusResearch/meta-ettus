# Add system XSA

FILESEXTRAPATHS:prepend:ni-titanium := "${THISDIR}/${PN}-${PV}:"

HDF_BASE:ni-titanium = "file://"
HDF_PATH:ni-titanium = "ni-titanium.xsa"
