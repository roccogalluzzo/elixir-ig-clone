defmodule ElixirIgClone.Uploaders.AvatarUploader do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  # @versions [:original, :thumb]
  @versions [:original]
  @extensions ~w(.jpg .jpeg .gif .png)

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname |> String.downcase

    case Enum.member?(@extensions, file_extension) do
      true -> :ok
      false -> {:error, "file type is invalid"}
    end
  end

  def transform(:thumb, _) do
    {:convert, "-thumbnail 100x100^ -gravity center -extent 100x100 -format png", :png}
  end

  def filename(version, _) do
    version
  end

  def storage_dir(_, {file, user}) do
    "uploads/avatars/#{user.id}"
  end
end
