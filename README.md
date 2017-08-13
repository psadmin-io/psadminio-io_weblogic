# io_weblogic

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with io_weblogic](#setup)
    * [What io_weblogic affects](#what-io_weblogic-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with io_weblogic](#beginning-with-io_weblogic)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This modules is meant to fill in the gaps between an Oracle delivered PeopleSoft
install via DPK and a running production system. Settings that cannot be conifgured
from the DPK will be settable here from Hiera.

## Module Description

We will not be supporting new installations of WebLogic or PeopleSoft from this module.
This will only augment PeopleSoft DPK installations as needed by the psadmin.io community.

Modules from the Puppet Forge may be dependencies for this module as defined in the metadata.
Being able to use Forge modules in your environment is likely to be required.

For an introduction to Puppet Check out these resources
* [Puppet Self-paced Training](https://learn.puppet.com/category/self-paced-training)
* [Puppet Learning VM](https://puppet.com/download-learning-vm)

## Setup

### What io_weblogic affects

* WebLogic PeopleSoft Domain setEnv.sh, JAVA_OPTIONS_${platform} subsettings
* WebLogic Peoplesoft Domain pskey file delivered with Peoplesoft

### Setup Requirements

* PeopleSoft installed via DPK (Puppet)
* Ability to use Puppet Forge modules in your deployment

### Beginning with io_weblogic

To use this module you must be a PeopleSoft customer using the DPK installer
process based on puppet to deploy nodes. This module is intended to run after the
WebLogic domain has been deployed to update settings not available in the delivered
installation process.

Data for the module will be pulled from Hiera. Depending on your setup, you may want
to create an additional profile to encapsulate the classes you want to use from this
module.

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

### io_weblogic::java_options
Hiera Example:
```yaml
io_weblogic::params::java_options:
  iepdmo:
    Xms:                              '1024m'
    Xmx:                              '1024m'
    Dweblogic.threadpool.MinPoolSize: '=100'
    Dhttps.protocols:                 '=TLSv1,TLSv1.1,TLSv1.2'
```

### io_weblogic::pskey
Hiera Example:
```yaml
io_weblogic::params::certificates:
  iepdmo:
    demo_key:
      certificate: /tmp/cert.pem
      private_key: /tmp/key.pem
    demo_key2:
      certificate: /tmp/cert2.pem
      private_key: /tmp/key2.pem
    demo_key3:
      certificate: /tmp/cert3.pem
```

## Limitations

This is where you list OS compatibility, version compatibility, etc.

## Development

Fork. Hack. TEST. PR :-)
