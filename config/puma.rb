# This configuration file will be evaluated by Puma. The top-level methods that
# are invoked here are part of Puma's configuration DSL. For more information
# about methods provided by the DSL, see https://puma.io/puma/Puma/DSL.html.

threads ENV.fetch("MIN_THREADS", 1), ENV.fetch("MAX_THREADS", 5)
workers ENV.fetch("WORKERS", 2)
port ENV.fetch("PORT", 3000)
environment ENV.fetch("RACK_ENV") { "development" }
