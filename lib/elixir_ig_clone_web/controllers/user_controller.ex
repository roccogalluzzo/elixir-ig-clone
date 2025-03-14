defmodule ElixirIgCloneWeb.UserController do
  use ElixirIgCloneWeb, :controller

  alias ElixirIgClone.Accounts
  alias ElixirIgClone.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, user: user, changeset: changeset)
    end
  end

  # PUT /users/:id/follow
  def follow(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    current_user = Accounts.get_current_user(conn.assigns.current_user.id)

    case Accounts.follow_user(current_user, user) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "User followed successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, _} ->
        conn
        |> put_flash(:error, "Error following user.")
        |> redirect(to: ~p"/users/#{user}")
    end
  end

  # DELETE /users/:id/unfollow
  def unfollow(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    current_user = Accounts.get_current_user(conn.assigns.current_user.id)

    case Accounts.unfollow_user(current_user, user) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "User unfollowed successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, _} ->
        conn
        |> put_flash(:error, "Error unfollowing user.")
        |> redirect(to: ~p"/users/#{user}")
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: ~p"/users")
  end
end
