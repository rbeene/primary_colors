defmodule AlexaDemo.Repo.Migrations.CreateAlexaDemo.Alexa.Color do
  use Ecto.Migration

  def change do
    create table(:alexa_colors) do
      add :color, :string
      add :user_id, references(:users, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:alexa_colors, [:user_id])
  end
end
