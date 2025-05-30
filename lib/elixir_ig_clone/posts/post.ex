defmodule ElixirIgClone.Posts.Post do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :description, :string
    field :image, ElixirIgClone.Uploaders.PostImageUploader.Type
    belongs_to :user, ElixirIgClone.Accounts.User
    timestamps(type: :utc_datetime)
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :description, :user_id])
    |> validate_required([:title, :description, :user_id])
  end

  def image_changeset(post, attrs) do
    post
    |> cast_attachments(attrs, [:image])
    |> validate_required([:image])
  end
end
