#!/bin/bash
mix deps.get
mix local.rebar --force
mix ecto.create
mix ecto.migrate

mix phx.server
