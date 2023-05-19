defmodule CheckboxTest.ItemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CheckboxTest.Items` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        desc: "some desc",
        name: "some name"
      })
      |> CheckboxTest.Items.create_item()

    item
  end
end
