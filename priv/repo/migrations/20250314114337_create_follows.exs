defmodule ElixirIgClone.Repo.Migrations.CreateFollows do
  use Ecto.Migration

  def change do
    create table(:follows) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :follow_to_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:follows, [:user_id])
    create index(:follows, [:follow_to_id])
    create index(:follows, [:user_id, :follow_to_id], unique: true)
  end
end
