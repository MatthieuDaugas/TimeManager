defmodule ApiTimeManagerWeb.ClockController do
  use ApiTimeManagerWeb, :controller

  alias ApiTimeManager.Clocks
  alias ApiTimeManager.Clocks.Clock

  action_fallback(ApiTimeManagerWeb.FallbackController)

  def index(conn, _params) do
    clocks = Clocks.list_clocks()
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, clock_params) do
    with {:ok, %Clock{} = clock} <- Clocks.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> render("show.json", clock: clock)
    end
  end

  def show(conn, %{"user_id" => user_id}) do
    clock = Clocks.get_clock(user_id)
    render(conn, "show.json", clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Clocks.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Clocks.update_clock(clock, clock_params) do
      render(conn, "show.json", clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Clocks.get_clock(id)

    with {:ok, %Clock{}} <- Clocks.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
