This README file contains information on the contents of the meta-mender-sulfur layer.

Please see the corresponding sections below for details.

Dependencies
============

- URI: https://github.com/mendersoftware/meta-mender.git
  - layers: meta-mender-core
  - branch: thud

- URI: https://github.com/EttusResearch/meta-ettus.git
  - layers: meta-sulfur
  - branch: thud

Patches
=======

Please submit any patches against the meta-mender-sulfur layer as github pull request

Maintainer: Jörg Hofrichter <joerg.hofrichter@ni.com>

Table of Contents
=================

  I. Adding the meta-mender-sulfur layer to your build


I. Adding the meta-mender-sulfur layer to your build
=================================================

    bitbake-layers add-layer meta-mender-sulfur
