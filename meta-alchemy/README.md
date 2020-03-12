This README file contains information on the contents of the meta-alchemy layer.

Please see the corresponding sections below for details.

Dependencies
============

- URI: git://git.openembedded.org/bitbake.git
  - branch: zeus

- URI: git://git.openembedded.org/openembedded-core.git
  - layers: meta
  - branch: zeus

- URI: git://git.openembedded.org/meta-openembedded.git
  - layers: meta-oe
  - branch: zeus

Patches
=======

Please submit any patches against the meta-alchemy layer via pull-request on github.

Maintainer: Jörg Hofrichter <joerg.hofrichter@ni.com>

Table of Contents
=================

  I. Adding the meta-alchemy layer to your build


I. Adding the ../meta-ettus/meta-alchemy layer to your build
=================================================

    bitbake-layers add-layer ../meta-ettus/meta-alchemy
