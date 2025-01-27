import Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :fz_vpn,
  wg_path: "wg",
  cli: FzVpn.CLI.Live

config :fz_wall,
  nft_path: "nft",
  cli: FzWall.CLI.Live

config :fz_http, FzHttpWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  # changed by release config
  secret_key_base: "dummy",
  # changed by release config
  live_view: [signing_salt: "dummy"],
  server: true

# Do not print debug messages in production
config :logger, level: :info

config :fz_http,
  connectivity_checks_url: "https://ping.firez.one/"
