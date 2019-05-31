defmodule DemoWeb.TableFilter.ShowCols do
  use Phoenix.LiveView

  alias Demo.Companies

  def render(assigns) do
    ~L"""
    <form phx-change="show_cols">
    <%= for {col,title} <- @cols do %>
      <input name="<%= col %>" type="hidden" value="false">
      <input type="checkbox" name="<%= col %>" value="true" <%= checked?(@show_cols[col]) %> ><%= title %>
    <% end %>
    </form>

  <table>

    <thead>
      <tr>
        <%= for {col,title} <- @cols do %>
          <%= if (String.to_existing_atom(@show_cols[col])) do %>
            <th><%= title %></th>
          <% end %>
        <% end %>
      </tr>
    </thead>

    <tbody>
      <%= for row <- @rows do %>
        <tr>
          <%= for {col,_title} <- @cols do %>
            <%= if (String.to_existing_atom(@show_cols[col])) do %>
              <td><%= Map.get(row,String.to_atom(col)) %></td>
            <% end %>
          <% end %>
        </tr>
      <% end %>
    </tbody>

    </table>
    """
  end

  def checked?(value) do
    case value do
      "true" -> "checked"
      "false" -> ""
    end
  end

  def mount(_, socket) do
    rows = Companies.list_customers()

    cols = [
      {"id","Id"}, {"customerName","Customer"} , {"contactFirstName","First Name"} , {"contactLastName","Last Name"},
      {"phone" , "Phone"} , {"addressLine1", "Address Line 1"} , {"addressLine2", "Address Line 2"} ,
      {"city","City"}, {"state", "State"} , {"postalCode","Postal Code"} , {"country" , "Country"} ,
      {"creditLimit", "Credit Limit"}
    ]

    show_cols = Enum.map(cols, fn {col,_} -> {col,"true"} end) |> Enum.into(%{})

    {:ok, assign(socket, rows: rows, show_cols: show_cols, cols: cols) }
  end

  def handle_event("show_cols", checked_cols , socket) do
    IO.inspect(checked_cols)
    {:noreply, assign(socket, show_cols: checked_cols)}
  end

  end
