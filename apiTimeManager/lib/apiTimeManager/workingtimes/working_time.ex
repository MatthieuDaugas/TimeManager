defmodule ApiTimeManager.WorkingTimes.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "working-times" do
    field :end, :naive_datetime
    field :start, :naive_datetime
    belongs_to :user, ApiTimeManager.Users.User

    timestamps()
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end])
    |> validate_required([:start, :end])
  end
end
