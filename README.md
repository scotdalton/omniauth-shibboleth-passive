# OmniAuth "Passive" Shibboleth Strategy

[![Gem Version](https://badge.fury.io/rb/omniauth-shibboleth-passive.png)](http://badge.fury.io/rb/omniauth-shibboleth-passive)
[![Build Status](https://api.travis-ci.org/scotdalton/omniauth-shibboleth-passive.png?branch=master)](https://travis-ci.org/scotdalton/omniauth-shibboleth-passive)
[![Dependency Status](https://gemnasium.com/scotdalton/omniauth-shibboleth-passive.png)](https://gemnasium.com/scotdalton/omniauth-shibboleth-passive)
[![Code Climate](https://codeclimate.com/github/scotdalton/omniauth-shibboleth-passive.png)](https://codeclimate.com/github/scotdalton/omniauth-shibboleth-passive)
[![Coverage Status](https://coveralls.io/repos/scotdalton/omniauth-shibboleth-passive/badge.png?branch=master)](https://coveralls.io/r/scotdalton/omniauth-shibboleth-passive)

OmniAuth strategy for Shibboleth in ["passive mode"](https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPProtectContent).

## Overview
The OmniAuth "Passive" Shibboleth Strategy extends [`OmniAuth::Shibboleth`](https://github.com/toyokazu/omniauth-shibboleth/) to
provide support for Shibboleth configured in ["passive mode"](https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPProtectContent).

Based on the configuration of the `:id_callback_frequency`, in cases where there is no SP Shibboleth session the strategy will redirect
to the IdP to try to establish a SP session.  Valid values for `:id_callback_frequency` are `:every_request`, `first_request` or a
[time specification](http://edgeguides.rubyonrails.org/active_support_core_extensions.html#time) `lambda`
(or anything that responds to `:call` and returns an object that is comparable to an instance of `Time`).
The default is `:every_request`.

