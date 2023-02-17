# io_weblogic

#### Table of Contents

- [io\_weblogic](#io_weblogic)
      - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Module Description](#module-description)
  - [Setup](#setup)
    - [What io\_weblogic affects](#what-io_weblogic-affects)
    - [Setup Requirements](#setup-requirements)
    - [Beginning with io\_weblogic](#beginning-with-io_weblogic)
  - [Usage](#usage)
    - [io\_weblogic::java\_options](#io_weblogicjava_options)
    - [io\_weblogic::pskey](#io_weblogicpskey)
    - [io\_weblogic::cacert](#io_weblogiccacert)
    - [io\_weblogic::jce](#io_weblogicjce)
    - [io\_weblogic::prebuilt\_pskey](#io_weblogicprebuilt_pskey)
    - [io\_weblogic::omc\_apm\_agent](#io_weblogicomc_apm_agent)
  - [Reference](#reference)
  - [Limitations](#limitations)
  - [Development](#development)

## Overview

This modules is meant to fill in the gaps between an Oracle delivered PeopleSoft
install via DPK and a running production system. Settings that cannot be conifgured
from the DPK will be settable here from Hiera.

To use this module you must be a PeopleSoft customer using the DPK installer
process based on puppet to deploy nodes. This module is intended to run after the
WebLogic domain has been deployed to update settings not available in the delivered
installation process.

Data for the module will be pulled from Hiera. Depending on your setup, you may want
to create an additional profile to encapsulate the classes you want to use from this
module.

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
* WebLogic PeopleSoft Domain setEnv.sh, SSL_KEY_STORE_PATH if you choose to use Standard JAVA Trust
* WebLogic Peoplesoft Domain pskey file delivered with Peoplesoft
* JAVA cacert password store password, if selected
* JAVA Unlimited Cryptography Extensions (JCE), if selected

### Setup Requirements

* PeopleSoft installed via DPK (Puppet)
* Ability to use Puppet Forge modules in your deployment
* Remove the line `data_binding_terminus = none` from your `puppet.conf` file

### Beginning with io_weblogic

`include '::io_weblogic'` is enough to get you up and running. To Change the defaults you can set them in hiera or pass them in.

## Usage

### io_weblogic::java_options

Java Options Will allow you to pass in a hash and set arbitrary values for the Java Options in setEnv.sh/setEnv.cmd.
This Class will be run by default if the io_weblogic::java_options hash is defined in hiera.

When using `-XX` values, the YAML key must be unique. To get around this limitation, you can use part of the value string for the key since the module simply concatenates the values in `setEnv.sh`.

Hiera Example:
```yaml
io_weblogic::java_options:
  iepdmo:
    -Xms:                              '1024m'
    -Xmx:                              '1024m'
    -Dweblogic.threadpool.MinPoolSize: '=100'
    -Dhttps.protocols:                 '=TLSv1,TLSv1.1,TLSv1.2'
    '-XX:+UseG1': 'GC'
    '-XX:+UseString': 'Deduplication'
    '-XX:G1Reserve': 'Percent=25'
    '-XX:InitiatingHeap': 'OccupancyPercent=30' 
    '-Dtuxedo.jolt.LLEDeprecationWarnLevel': '=NONE'
```

### io_weblogic::pskey

The pskey class will load certificates in to your pskey store from a hash and set the password for pskey if desired.

pskey will run when either of the following are true:
1. io_weblogic::certificates is defined
1. io_weblogic::pskey_passwd is set to something other than the default

Hiera Example:
```yaml
io_weblogic::pskey_passwd: 'supersecret'

io_weblogic::certificates:
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

### io_weblogic::cacert

The cacert class has two functions, it can change the password for the delivered JAVA cacert keystore and change the SSL_KEY_STORE_PATH
in setEnv.sh/setEnv.cmd. 

This is used if you would like to avoid adding common root certificates to your delivered pskey and instead use the standart trust
delivered with JAVA.

cacert will run when either of the following are true:
1. io_weblogic::standard_java_trust is set to true
1. io_weblogic::cacert_passwd is set to something other than the default

When run it will set the password, if defined and update setEnv for JAVA trust, if true.

Hiera Example:
```yaml
io_weblogic::cacert_passwd:       'supersecret'
io_weblogic::standard_java_trust: true
```

### io_weblogic::jce

The JCE class downloads and installs the JAVA Unlimited Cryptography Extensions needed for setting up WebLogic for SSL

This class will be run if the install_jce flag is set to true.

By default the class will download the JCE files directly from Oracle. 1.7 for PT 8.55/8.54 and 1.8 for 8.56. See the
hiera example for an example of how to pass in a path or another URL.

For extracting the archives you will need `unzip` on Linux or `7zip` on Windows.

Hiera Example:
```yaml
io_weblogic::install_jce: true
io_weblogic::jce_archive_path: (alternate filesystem path or URL)
```

### io_weblogic::prebuilt_pskey

This class will deploy a pre-built `pskey` file from a location into your PIA domain. Unlike the `pskey` class, the `prebuilt_pskey` class does not interact with the delivered file. Instead, the class overwrites the delivered file with your custom `pskey` file.

Hiera Example:
```yaml
io_weblogic::prebuilt_pskey: /path/to/nfs/share/pskey
```

### io_weblogic::omc_apm_agent

This class will deploy the Oracle Management Cloud APM agent to your PIA domain. The class assumes you have downloaded the APM agent from the OMC site and unzipped it to a common location. Add your registration key and the class will install the APM agent into your PIA domain. You must also add the necessary `JAVA_OPTIONS` as well so the APM agent is loaded when the domain starts.

Hiera Example:
```yaml
io_weblogic::omc_apm_agent:    true
io_weblogic::apm_install_dir:  /nfs/share/apm
io_weblogic::apm_reg_key:      '<Registration Key from OMC console>'
io_weblogic::java_home:        "%{hiera('jdk_location')}
```

## Reference

## Limitations

This is where you list OS compatibility, version compatibility, etc.

## Development

Fork. Hack. TEST. PR :-)
