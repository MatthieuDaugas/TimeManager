defmodule ApiTimeManagerWeb.ClockView do
  use ApiTimeManagerWeb, :view
  alias ApiTimeManagerWeb.ClockView

  def render("index.json", %{clocks: clocks, count: count}) do
    %{data: render_many(clocks, ClockView, "clock.json"), count: count}
  end

  def render("show.json", %{clock: clock}) do
    %{data: render_one(clock, ClockView, "clock.json")}
  end

  def render("clock.json", %{clock: clock}) do
    %{id: clock.id,
      time: clock.time,
      status: clock.status}
  end
end
