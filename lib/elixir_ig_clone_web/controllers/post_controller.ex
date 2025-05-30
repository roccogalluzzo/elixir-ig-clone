defmodule ElixirIgCloneWeb.PostController do
  use ElixirIgCloneWeb, :controller

  alias ElixirIgClone.Posts
  alias ElixirIgClone.Posts.Post

  def index(conn, _params) do
    user = conn.assigns.current_user
    posts = Posts.list_posts_for_user(user.id)
    render(conn, :index, posts: posts, user: user)
  end

  def new(conn, _params) do
    user = conn.assigns.current_user

    changeset = Posts.change_post(%Post{})
    render(conn, :new, changeset: changeset, user: user)
  end

  def create(conn, %{"post" => post_params}) do
    user = conn.assigns.current_user
    post_params = Map.put(post_params, "user_id", user.id)

    case Posts.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: ~p"/posts/#{post.id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset, user: user)
    end

  end

  def show(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    post = Posts.get_post!(id)
    render(conn, :show, post: post, user: user)
  end

  def edit(conn, %{"user_id" => user_id, "id" => id}) do
    user = conn.assigns.current_user
    post = Posts.get_post!(id)

    if post.user_id == user.id do
      changeset = Posts.change_post(post)
      render(conn, :edit, post: post, changeset: changeset, user: user)
    else
      conn
      |> put_flash(:error, "You are not authorized to edit this post.")
      |> redirect(to: ~p"/users/#{user_id}/posts")
    end
  end

  def update(conn, %{"user_id" => user_id, "id" => id, "post" => post_params}) do
    user = conn.assigns.current_user
    post = Posts.get_post!(id)

    if post.user_id == user.id do
      case Posts.update_post(post, post_params) do
        {:ok, post} ->
          conn
          |> put_flash(:info, "Post updated successfully.")
          |> redirect(to: ~p"/users/#{user_id}/posts/#{post.id}")

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, :edit, post: post, changeset: changeset, user: user)
      end
    else
      conn
      |> put_flash(:error, "You are not authorized to update this post.")
      |> redirect(to: ~p"/users/#{user_id}/posts")
    end
  end

  def delete(conn, %{"user_id" => user_id, "id" => id}) do
    user = conn.assigns.current_user
    post = Posts.get_post!(id)

    if post.user_id == user.id do
      {:ok, _post} = Posts.delete_post(post)

      conn
      |> put_flash(:info, "Post deleted successfully.")
      |> redirect(to: ~p"/users/#{user_id}/posts")
    else
      conn
      |> put_flash(:error, "You are not authorized to delete this post.")
      |> redirect(to: ~p"/users/#{user_id}/posts")
    end
  end
end
