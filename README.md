MobileProvision [![Build Status](https://travis-ci.org/appaloosa-store/mobile_provision.svg?branch=master)](https://travis-ci.org/appaloosa-store/mobile_provision)
===

MobileProvision is a simple Mobile Provision wrapper written in Ruby.

Installation
---
To install *MobileProvision*:

```
$ gem install mobile_provision
```

Or you can include this in your project's `Gemfile`:

```
gem 'mobile_provision'
```

Then execute:

```
$ bundle
```
Usage
---

```
mobile_provision_file = File.open(path_to_mobile_prov)
mobile_provision = MobileProvision.new(mobile_provision_file)
p mobile_provision.expiration_date
p mobile_provision.profile_type # => either ad-hoc, in house, apple store or in error
p mobile_provision.registered_udids if mobile_provision.profile_type == AD_HOC
mobile_provision_file.close
```

Extractible info
---
Currently, we can extract:

+ expiration date
+ bundle id
+ certificate
+ profile type
+ registered UDIDs in case of an Ad-Hoc type

Contributing
---
1. Fork it ( https://github.com/appaloosa-store/mobile_provision )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request