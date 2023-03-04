# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :ddco2,
  # Log data to StatsD every 15 seconds:
  interval: 15_000,
  # Use "co2mini.*" for StatsD keys:
  prefix: "co2mini",
  # Add tags (optional):
  tags: ["location:basement"]

# Configure logger:
config :logger, :console,
  # Remove debugging messages:
  level: :info

# If you don't want the timestamp (e.g. running under `runit`):
#  format: "[$level] $message\n"
