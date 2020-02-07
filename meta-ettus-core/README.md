This README file contains information on the contents of the meta-ettus/meta-ettus-core/ layer.

Please see the corresponding sections below for details.

Dependencies
============

- URI: git://git.openembedded.org/bitbake.git
  - branch: thud

- URI: git://git.openembedded.org/openembedded-core.git
  - layers: meta
  - branch: thud

- URI: git://git.openembedded.org/meta-openembedded.git
  - layers: meta-oe meta-python meta-filesystems meta-networking
  - branch: thud

- URI: https://github.com/balister/meta-sdr.git
  - layers: meta-sdr (parent directory)
  - branch: thud

Patches
=======

Please submit any patches against the meta-ettus/meta-ettus-core/ layer via github pull requests.

Maintainer: Jörg Hofrichter <joerg.hofrichter@ni.com>

Table of Contents
=================

  I. Adding the meta-ettus/meta-ettus-core/ layer to your build


I. Adding the meta-ettus/meta-ettus-core/ layer to your build
=================================================

    bitbake-layers add-layer meta-ettus/meta-ettus-core/
