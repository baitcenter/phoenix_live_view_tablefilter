defmodule DemoWeb.TableFilter.Filtrex do
  use Phoenix.LiveView

  import Phoenix.HTML.Form

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

  <form phx-change="table">
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
              <%= select(@form, String.to_atom(col),Map.get(@select,col),selected: @filter[col]) %>
            <% end %>
            <%= if (Enum.member?(@search_list,col)) do %>
              <%= text_input @form, String.to_atom(col), value: query(@filter,col) %>
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
  </form>
    """
  end

  def checked?(value) do
    case value do
      "true" -> "checked"
      "false" -> ""
    end
  end

  def selected?(filter,key,val) do
    #IO.inspect(filter)
    #IO.inspect(key)
    #IO.inspect(val)
    key = key <> "_equals"
    case (Map.has_key?(filter, key)) do
      true -> case filter[key]==val do
        true -> "selected"
        false -> ""
      end
      false -> case val=="All" do
        true -> "selected"
        false -> ""
      end
      end
    end

    #get the value in the filter map for the key in param or return ""
    def query(filter,key) do
      cond do
        (Map.has_key?(filter, key)) ->
          case filter[key] do
            {_,v} -> v
            _ -> filter[key]
          end
        true -> ""
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
    ~w(country state city)
  end

  #List of columns to search values (input)
  def get_search_list do
    ~w(customerName phone creditLimit postalCode contactFirstName contactLastName)
  end

  def get_cols do
    #should get the cols from a database or a json config file
    [ {"id","Id"}, {"customerName","Customer"} , {"contactFirstName","First Name"} , {"contactLastName","Last Name"},
      {"phone" , "Phone"} ,  {"city","City"}, {"state", "State"} ,
       {"postalCode","Postal Code"} , {"country" , "Country"} , {"creditLimit", "Credit Limit"} ]
  end

  def get_rows do
    Companies.list_customers()
  end

  def get_filter_rows(filter) do
    Companies.filter_customers(filter)
  end

  def mount(_, socket) do
    rows = get_rows()

    cols = get_cols()
    form = :customer
    show_cols = Enum.map(cols, fn {col,_} -> {col,"true"} end) |> Enum.into(%{})

    #search_list: List of columns to search values (input)
    search_list = get_search_list()

    #filter_list: List of columns to filter with dropdown list
    filter_list = get_filter_list()

    #select : Map containting for each col of filter_list the list of values from rows
    select = select_list(filter_list,rows)
    IO.inspect(select)

    {:ok, assign(socket, rows: rows, show_cols: show_cols, cols: cols, form: form,
              filter_list: filter_list,search_list: search_list,select: select, filter: %{} ) }
  end

  def handle_event("show_cols", checked_cols , socket) do
    IO.inspect(checked_cols)
    {:noreply, assign(socket, show_cols: checked_cols)}
  end

  #reset filters : each col filter is set to "All"
  def handle_event("reset", _, socket) do
    rows = get_rows()
    select =
      get_filter_list()
      |> select_list(rows)
    filter =
      Enum.map(get_filter_list(), fn c->{c,"All"} end)
      |> Enum.into(%{})
    {:noreply, assign(socket, rows: rows, select: select, filter: filter)}
  end


  #new version : filter is a map of all the values of the form.
  #needs to go through all the values and if a value equals "All" ignore it
  #filter -> equals
  #search -> contains , = , >,  ....
  def handle_event(_, filter , socket) do
    IO.inspect(filter)
    form = Atom.to_string(socket.assigns.form)
    new_filter =
      Enum.map(filter[form],&rename_key/1)
      |> Enum.reject(fn {_,val} -> val=="All" || val=="" end )
      |> Enum.into(%{})
    IO.inspect(new_filter)
    filtered_rows = get_filter_rows(new_filter)
    case filtered_rows do
      [] -> {:noreply, socket}
      _ ->  select = get_filter_list() |> select_list(filtered_rows)
            {:noreply, assign(socket, rows: filtered_rows, filter: filter[form], select: select) }
    end
  end


  #rename the key to be used by filtrex, adds _equals, _contains ... to the column name
  #delete >,<,= on the value
def rename_key({key,val}) do
  char2 = String.at(val,1)

  IO.inspect(key)
  new_key = case String.at(val,0) do
  ">" -> key <> "_greater_than" <> equal?(char2)
  "<" -> key <> "_less_than" <> equal?(char2)
  "=" -> key <> "_equals"
  _   -> cond do
    Enum.member?(get_filter_list(), key) -> key <> "_equals"
    true -> key <> "_contains"
    end
  end

  IO.inspect(new_key)
  new_val = String.replace(val, ">", "") |> String.replace("<", "") |> String.replace( "=", "")
  {new_key, new_val}
end


defp equal?(char) do
  case char do
    "=" -> "_or"
     _ -> ""
  end
end


end
