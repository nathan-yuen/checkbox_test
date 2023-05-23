defmodule CheckboxTestWeb.ItemLive.Index do
  use CheckboxTestWeb, :live_view

  alias CheckboxTest.Items
  alias CheckboxTest.Items.Item

  @impl true
  def mount(_params, _session, socket) do
    items = Items.list_items()
    |> Enum.map(fn item -> {item, false} end)

    {:ok,
    stream_configure(socket, :items, dom_id: &("item-#{elem(&1, 0).id}"))
    |> assign(:items, items)
    |> stream(:items, items)
    |> assign(:selected_ids, %{})
  }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Item")
    |> assign(:item, Items.get_item!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Item")
    |> assign(:item, %Item{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Items")
    |> assign(:item, nil)
  end

  @impl true
  def handle_info({CheckboxTestWeb.ItemLive.FormComponent, {:saved, item}}, socket) do
    {:noreply, stream_insert(socket, :items, item)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    item = Items.get_item!(id)
    {:ok, _} = Items.delete_item(item)

    {:noreply, stream_delete(socket, :items, item)}
  end

  def handle_event("toggle", %{"id" => item_id} = params, socket) do
    checked = Map.has_key?(params, "value")
    ids = if checked do
      Map.put(socket.assigns.selected_ids, item_id, true)
    else
      Map.delete(socket.assigns.selected_ids, item_id)
    end
    item = Items.get_item!(item_id)

    {:noreply,
      assign(socket, :selected_ids, ids)
      |> stream_insert(:items, {item, checked})
      |> assign(:items, Enum.map(socket.assigns.items, fn {item, _checked} -> {item, Map.has_key?(ids, item.id)} end))
    }
  end

  def handle_event("select-all", _params, socket) do
    items = Items.list_items()
    ids = items
      |> Enum.reduce(socket.assigns.selected_ids, fn item, acc ->
        Map.put(acc, item.id, true)
      end)

    {:noreply, assign(socket, :selected_ids, ids)
      |>stream(:items, Enum.map(items, fn item ->
        {item, true}
      end), dom_id: &("item-#{elem(&1, 0).id}"), reset: true)
      |> assign(:items, Enum.map(socket.assigns.items, fn {item, _checked} -> {item, true} end))
    }
  end
end
