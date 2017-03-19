defmodule AlexaDemo.Alexa.Color do
  use Ecto.Schema
  alias AlexaDemo.Alexa.Color

  schema "alexa_colors" do
    field :color, :string
    belongs_to :user, Authable.Model.User, type: :binary_id

    timestamps()
  end

end
