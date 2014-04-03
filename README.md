# TestServer - the endpoint for your proxy server tests

[![Build Status](https://travis-ci.org/dg-vrnetze/test_server.png?branch=master)](https://travis-ci.org/dg-vrnetze/test_server)
[![Code Climate](https://codeclimate.com/github/dg-vrnetze/test_server.png)](https://codeclimate.com/github/dg-vrnetze/test_server)
[![Coverage Status](https://coveralls.io/repos/dg-vrnetze/test_server/badge.png?branch=master)](https://coveralls.io/r/dg-vrnetze/test_server?branch=master)
[![Gem Version](https://badge.fury.io/rb/test_server.png)](http://badge.fury.io/rb/test_server)


`test_server` *serves two main purposes:*

* end point for your proxy tests.
* load generator via simple website driven by javascript

*Behind the scenes it mainly uses ...*

* [jquery](http://jquery.com/)
* [sinatra](http://www.sinatrarb.com)
* and other wonderfull gems 

*Possible use cases:*

* Provide static data via web application to make your tests reliable 
* Generate load via browsers typically used by your users

## Installation

### Rubygems

Add this line to your application's Gemfile:

    gem 'test_server'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install test_server

### Archlinux

```bash
# Install via yaourt
yaourt -S test_server

# Install via cower + makepkg
cower -d test_server
cd <dir>
makepkg -is
```

### Firewall rules

Following you can find an example configuration for iptables to secure your server. It
opens ports only for your proxy servers to access `test_server`.

```bash
# default policies
iptables -P INPUT -j DROP
iptables -P FORWARD -j DROP
iptables -P OUTPUT -j ACCEPT

# user defined chains
iptables -N TCP
iptables -N UDP

# rules
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
iptables -A INPUT -p icmp -m icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -j TCP
iptables -A INPUT -p tcp -m recent --set --name TCP-PORTSCAN --mask 255.255.255.255 --rsource -j REJECT --reject-with tcp-reset
iptables -A INPUT -p udp -m recent --set --name UDP-PORTSCAN --mask 255.255.255.255 --rsource -j REJECT --reject-with icmp-port-unreachable
iptables -A INPUT -j REJECT --reject-with icmp-proto-unreachable
iptables -A TCP -p tcp -m recent --update --seconds 60 --name TCP-PORTSCAN --mask 255.255.255.255 --rsource -j REJECT --reject-with tcp-reset
iptables -A TCP -s <public ips proxies> -p tcp -m tcp --dport 8000 -j ACCEPT
iptables -A UDP -p udp -m recent --update --seconds 60 --name UDP-PORTSCAN --mask 255.255.255.255 --rsource -j REJECT --reject-with icmp-port-unreachable
COMMIT
```

## Screenshots

To be defined...

## Usage

*Starting Web Application*

```
% test_server serve
```

*Load testing*

Point your browser to `http://<your-domain.org>/v1/test/javascript/xhr/string`.
Fill out the form and run test.

*Testing your proxies*

* Write tests using `capybara` + `rspec`.

or

* Use [`proxy_tester`](https://github.com/dg-vrnetze/proxy_tester) for a fully
  featured solution for writing proxy tests (**RECOMMENDED**). `proxy_tester` uses
  `capybara` and `rspec`, but provides lots of helpers for writing proxy tests
  to reduce the work on your site.

## List of test end points

To be defined. Hopefully I can provide a `controller` which handles this within
the application.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/test_server/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
