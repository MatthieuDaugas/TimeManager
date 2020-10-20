defmodule ApiTimeManagerWeb.WorkingTimeController do
  use ApiTimeManagerWeb, :controller

  alias ApiTimeManager.WorkingTimes
  alias ApiTimeManager.WorkingTimes.WorkingTime

  action_fallback ApiTimeManagerWeb.FallbackController

  def index(conn, _params) do
    working_times = WorkingTimes.list_working_times()
    render(conn, "index.json", working_times: working_times)
  end

  def create(conn, params) do
    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.create_working_time(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.working_time_path(conn, :get_one, params["user_id"], working_time))
      |> render("show.json", working_time: working_time)
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)
    render(conn, "show.json", working_time: working_time)
  end

  def update(conn, working_time_params) do
    working_time = WorkingTimes.get_working_time!(working_time_params["id"])
    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.update_working_time(working_time, working_time_params) do
      render(conn, "show.json", working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- WorkingTimes.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_all(conn, params) do
    working_times = WorkingTimes.get_working_time_all(params)
    render(conn, "index.json", working_times: working_times)
  end

  def get_one(conn,params) do
    working_time = WorkingTimes.get_working_time_one(params)
    render(conn, "show.json", working_time: working_time)
  end
end
