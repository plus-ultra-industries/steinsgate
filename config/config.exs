import Config

config :steins,
  port: String.to_integer(System.get_env("PORT") || "4000")
