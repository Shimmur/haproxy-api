HAproxy-API
===========

This application is a companion to
[Sidecar](https://github.com/newrelic/sidecar) that allows you to run HAproxy
and Sidecar in individual Docker containers that can be deployed separately. This
has the advantage of not taking down HAproxy while redeploying Sidecar. It is
not a general purpose API and relies heavily on the encoding of the state used
by Sidecar.

This application will manage HAproxy by either running it or restarting it
after templating out a configuration from the provided Sidecar state.

Generally you will run this on the same host as the Sidecar instance it is
subscribed to. There might be situations like frontend gateways where it makes
sense to subscribe it to a remote Sidecar instance. Its sole job is to receive
state from Sidecar and configure/manage HAproxy.

You may *instead* also run HAproxy-API in a follower mode where it can manage a
local HAproxy while subscribing to a remote Sidecar. This is particularly
useful for local development work. It is probably not the best configuration
for production. This mode is triggered either by supplying a `hostname:port`
combination with the `-F` flag or by supplying the `HAPROXY_API_FOLLOW`
environment variable where the vlaue is `hostname:port` of a remote or local
Sidecar.

Building it
-----------

... is simple. Just run `go build`.

Running it
----------

... is equally simple. Just run `??? Ask Karl (again :)) ???`.

Configuration
-------------

There is a sample configuration in [haproxy-api.toml](haproxy-api.toml),
including comments on what each item means. Generally you need to know the
remote URL of a Sidecar instance you will connect to. If you run in host
networking mode this will be `http://localhost:7777/state.json` if you have a
custom Docker network, then it will be somethign like `http://<name of Sidecar
container>:7777/state.json`. This URL is used for bootstrapping the container
because we don't have any stored state. It will then receive updates from
Sidecar itself (if you've configured it to publish them), and won't make any
further calls to Sidecar.

Health Checking
---------------

`haproxy-api` can be health checked by sending a `GET` request to the `/health`
endpoint. This in turn simply checks to make sure that HAproxy is currently
running by shelling out to `bash`, `ps`, and `grep`.

Installation
------------

From the source code ...

* install golang
* clone the repo
* run `make test && make build`

Running
-------

You (obviously) need to have haproxy installed (`sudo apt install haproxy`).

And you might need to add an alias on the loopback by running `sudo ./alias.sh`.

You then need to edit the `haproxy-api.toml` file to point to your
singularity instance/installation.

Note: If your singularity instance is on a VPN you need to get access to the VPN.

You can then start `haproxy` with ...

```bash
./haproxy-api --config-file ./haproxy-api.toml
```

... with (in follow mode) ...

```bash
./haproxy-api -F <singularity-ip:singularity-port>
```
