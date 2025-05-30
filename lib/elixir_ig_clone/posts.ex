defmodule ElixirIgClone.Posts do
  import Ecto.Query, warn: false
  alias ElixirIgClone.Repo
  alias ElixirIgClone.Posts.Post

  def list_posts do
    Repo.all(Post)
  end

  def get_post!(id), do: Repo.get!(Post, id)

  def create_post(attrs \\ %{}) do
    Repo.transaction(fn ->
      with {:ok, post} <-
             %Post{}
             |> Post.changeset(attrs)
             |> Repo.insert(),
           {:ok, post} <-
             post
             |> Post.image_changeset(attrs)
             |> Repo.update() do
        post
      else
        error -> Repo.rollback(error)
      end
    end)
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  def list_posts_for_user(user_id) do
    Post
    |> where([p], p.user_id == ^user_id)
    |> Repo.all()
  end
end
