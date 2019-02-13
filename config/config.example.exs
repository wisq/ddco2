# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :ddco2,
  # Log data to StatsD every 15 seconds:
  interval: 15_000,
  # Use "co2mini.*" for StatsD keys:
  prefix: "co2mini"

config :statix, DDCO2.Statix,
  # Host to send stats to:
  host: "127.0.0.1",
  # Port to send to:
  port: 8125

# Configure logger:
config :logger, :console,
  # Remove debugging messages:
  level: :info

# If you don't want the timestamp (e.g. running under `runit`):
#  format: "[$level] $message\n"
