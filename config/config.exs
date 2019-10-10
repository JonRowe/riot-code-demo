use Mix.Config

# Interval is measured in milliseconds
config :riot, interval: 1 * 60 * 1000

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
