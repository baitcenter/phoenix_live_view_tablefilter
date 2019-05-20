defmodule DemoWeb.TableFilter.FilterCols do
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


    <center><button phx-click="reset">RESET FILTERS</button></center>

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
    <tr>
      <%= for {col,_} <- @cols do %>
        <%= if (String.to_existing_atom(@show_cols[col])) do %>
          <td style="min-width:70px">
            <%= if (Enum.member?(@filter_list,col)) do %>
              <form phx-change="filter">
                <SELECT name="<%= col %>">
                <%= for value <- Map.get(@select,col) do %>
                  <OPTION value="<%= value %>" <%= (selected?(@filter,col,value)) %> > <%= value %>
                <% end %>
                </SELECT>
              </form>
            <% end %>
          </td>
        <% end %>
      <% end %>
    </tr>

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

  def selected?(filter,key,type) do
    case (Map.has_key?(filter, key)) do
      true -> case filter[key]==type do
        true -> "selected"
        false -> ""
      end
      false -> ""
      end
    end

  #get the list of values from rows for the column filter
  def get_list(rows, filter) do
    list =
      Enum.map(rows, fn r -> Map.get(r,String.to_atom(filter)) end)
      |> Enum.uniq()
      |> Enum.sort()
    ["All" | list]
  end

  #get the list of values from rows for each column of col_list
  def select_list(col_list,rows) do
    Enum.map(col_list, fn c ->
      { c, get_list(rows,c) }
      end)
    |> Enum.into(%{})
  end

  def get_filter_list do
    ["country","state","city"]
  end

  def get_cols do
    #should get the cols from a database or a json config file
    [ {"id","Id"}, {"customerName","Customer"} , {"contactFirstName","First Name"} , {"contactLastName","Last Name"},
      {"phone" , "Phone"} , {"addressLine1", "Address Line 1"} , {"addressLine2", "Address Line 2"} ,
      {"city","City"}, {"state", "State"} , {"postalCode","Postal Code"} , {"country" , "Country"} ,
      {"creditLimit", "Credit Limit"} ]
  end

  def get_rows do
    Companies.list_customers()
  end

  def get_filter_rows(filter) do
    Companies.query_table(filter)
  end

  def mount(_, socket) do
    rows = get_rows()

    cols = get_cols()
    show_cols = Enum.map(cols, fn {col,_} -> {col,"true"} end) |> Enum.into(%{})

    #filter_list : List of columns to filter with dropdown list
    filter_list = get_filter_list()

    #select : Map containting for each col of filter_list the list of values from rows
    select = select_list(filter_list,rows)
    IO.inspect(select)

    #filter is set to All for each column
    filter = Enum.map(filter_list, fn col -> {col,"All"} end) |> Enum.into(%{})

    {:ok, assign(socket, rows: rows, show_cols: show_cols, cols: cols,
    filter_list: filter_list, select: select, filter: filter ) }
  end

  def handle_event("show_cols", checked_cols , socket) do
    IO.inspect(checked_cols)
    {:noreply, assign(socket, show_cols: checked_cols)}
  end

  #reset filters : each col filter is set to "All"
  def handle_event("reset", _, socket) do
    rows = get_rows()
    filter_list = socket.assigns.filter_list
    select = select_list(filter_list,rows)
    filter =
      Enum.map(filter_list, fn col -> {col,"All"} end)
      |> Enum.into(%{})

    {:noreply, assign(socket, rows: rows, select: select, filter: filter)}
  end

  #filter : add new filter to the socket
  #unless the filter is All, in this case previous filter for this column is deleted
  def handle_event("filter", filter , socket) do
    IO.inspect(filter)
    key = hd(Map.keys(filter))
    val = filter[key]
    new_filter = case val do
      "All" -> socket.assigns.filter |> Map.delete(key)
        _   -> socket.assigns.filter |> Map.merge(filter)
    end

    filter_rows = get_filter_rows(new_filter)
    select =
      socket.assigns.filter_list
      |> select_list(filter_rows)
      {:noreply, assign(socket, rows: filter_rows, filter: new_filter, select: select)}
  end

end
