defmodule AlexaDemo.Alexa do
  import Ecto.Changeset
  import Ecto.Query
  alias AlexaDemo.Alexa.{Color, Response}
  alias AlexaDemo.Repo
  alias Authable.Model.User
  @moduledoc """
  The boundary for the Alexa system.
  """

  def generate_response(opts), do: Response.generate_response(opts)

  @doc """
  Returns the list of colors.

  ## Examples

      iex> list_colors()
      [%Color{}, ...]

  """
  def list_colors do
    Repo.all(Color)
  end

  @doc """
  Gets a single color.

  Raises `Ecto.NoResultsError` if the Color does not exist.

  ## Examples

      iex> get_color!(123)
      %Color{}

      iex> get_color!(456)
      ** (Ecto.NoResultsError)

  """
  def get_color!(id), do: Repo.get!(Color, id)

  def get_color_by_user(user), do: Repo.get_by(Color, user_id: user.id)

  def create_favorite_color(%User{} = user, color) do
    from(c in Color, where: c.user_id == ^user.id) |> Repo.delete_all
    changeset = cast(%Color{}, %{color: color}, [:color])
                |> put_assoc(:user, user)
    {:ok, color} = Repo.insert(changeset)
  end

  @doc """
  Creates a color.

  ## Examples

      iex> create_color(%{field: value})
      {:ok, %Color{}}

      iex> create_color(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_color(attrs \\ %{}) do
    %Color{}
    |> color_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a color.

  ## Examples

      iex> update_color(color, %{field: new_value})
      {:ok, %Color{}}

      iex> update_color(color, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_color(%Color{} = color, attrs) do
    color
    |> color_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Color.

  ## Examples

      iex> delete_color(color)
      {:ok, %Color{}}

      iex> delete_color(color)
      {:error, %Ecto.Changeset{}}

  """
  def delete_color(%Color{} = color) do
    Repo.delete(color)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking color changes.

  ## Examples

      iex> change_color(color)
      %Ecto.Changeset{source: %Color{}}

  """
  def change_color(%Color{} = color) do
    color_changeset(color, %{})
  end

  defp color_changeset(%Color{} = color, attrs) do
    color
    |> cast(attrs, [:color])
    |> validate_required([:color])
  end
end
