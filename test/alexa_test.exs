defmodule AlexaDemo.AlexaTest do
  use AlexaDemo.DataCase

  alias AlexaDemo.Alexa
  alias AlexaDemo.Alexa.Color

  @create_attrs %{color: "some color"}
  @update_attrs %{color: "some updated color"}
  @invalid_attrs %{color: nil}

  def fixture(:color, attrs \\ @create_attrs) do
    {:ok, color} = Alexa.create_color(attrs)
    color
  end

  test "list_colors/1 returns all colors" do
    color = fixture(:color)
    assert Alexa.list_colors() == [color]
  end

  test "get_color! returns the color with given id" do
    color = fixture(:color)
    assert Alexa.get_color!(color.id) == color
  end

  test "create_color/1 with valid data creates a color" do
    assert {:ok, %Color{} = color} = Alexa.create_color(@create_attrs)
    assert color.color == "some color"
  end

  test "create_color/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Alexa.create_color(@invalid_attrs)
  end

  test "update_color/2 with valid data updates the color" do
    color = fixture(:color)
    assert {:ok, color} = Alexa.update_color(color, @update_attrs)
    assert %Color{} = color
    assert color.color == "some updated color"
  end

  test "update_color/2 with invalid data returns error changeset" do
    color = fixture(:color)
    assert {:error, %Ecto.Changeset{}} = Alexa.update_color(color, @invalid_attrs)
    assert color == Alexa.get_color!(color.id)
  end

  test "delete_color/1 deletes the color" do
    color = fixture(:color)
    assert {:ok, %Color{}} = Alexa.delete_color(color)
    assert_raise Ecto.NoResultsError, fn -> Alexa.get_color!(color.id) end
  end

  test "change_color/1 returns a color changeset" do
    color = fixture(:color)
    assert %Ecto.Changeset{} = Alexa.change_color(color)
  end
end
