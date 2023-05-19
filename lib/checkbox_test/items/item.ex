defmodule CheckboxTest.Items.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :desc, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :desc])
    |> validate_required([:name, :desc])
  end
end
