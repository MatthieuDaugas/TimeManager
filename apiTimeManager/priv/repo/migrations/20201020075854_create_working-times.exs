defmodule ApiTimeManager.Repo.Migrations.CreateWorking-times do
  use Ecto.Migration

  def change do
    create table(:working-times) do
      add :start, :naive_datetime
      add :end, :naive_datetime
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:working-times, [:user_id])
  end
end
