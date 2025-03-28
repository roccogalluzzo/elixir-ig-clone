defmodule ElixirIgClone.Accounts.Follow do
  use Ecto.Schema
  import Ecto.Changeset

  schema "follows" do
    belongs_to :user, ElixirIgClone.Accounts.User
    belongs_to :follow_to, ElixirIgClone.Accounts.User

    # field :user_id, :id
    # field :follow_to_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(follow, attrs) do
    follow
    |> cast(attrs, [])
    |> validate_required([:user_id, :follow_to_id])
  end
end
