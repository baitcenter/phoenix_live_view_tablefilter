defmodule Demo.Companies do
   @moduledoc """
  The Companies context.
  """

  import Ecto.Query, warn: false
  import Filtrex.Type.Config

  alias Demo.Repo
  alias Demo.Companies.Customer

  @doc """
  Returns the list of customers.

  ## Examples

      iex> list_customers()
      [%Customer{}, ...]

  """
  def list_customers do
    Repo.all(Customer)
  end



  def filter_customers(user_filter) do
    case Filtrex.parse_params(filter_config(:customers), user_filter) do
      {:ok, filter} ->
      IO.inspect(filter)
      IO.inspect(user_filter)
      Customer |> Filtrex.query(filter) |> Repo.all()
      {:error, error} -> []
    end
  end

  defp filter_config(:customers) do
    defconfig do
        text :customerName
        text :contactLastName
        text :contactFirstName
        text :phone
        text :addressLine1
        text :addressLine2
        text :city
        text :state
        text :postalCode
        text :country
        number :creditLimit, allow_decimal: true
         #TODO add config for creditLimit of type decimal
    end
  end

  #FUNCTIONS TO BE USED WITHOUT FILTREX
  defp base_query do
    from c in Customer
  end

  def query_table(criteria) do
    base_query()
    |> build_query(criteria)
    |> Repo.all()
  end

  defp build_query(query, criteria) do
    Enum.reduce(criteria, query, &compose_query/2)
  end

  defp compose_query({_, "All"}, query) do
    query
  end

  defp compose_query( { k, {op , val} } = _filter ,query) do
    case op do
      "=" ->
        string = "%" <> val <> "%"
        where(query, [c], like( field(c,^String.to_atom(k)) , ^string))
      ">" -> where(query, [c], field(c,^String.to_atom(k)) > ^String.slice(val, 1..-1))
      "<" -> where(query, [c], field(c,^String.to_atom(k)) < ^String.slice(val, 1..-1))
      ">=" -> where(query, [c], field(c,^String.to_atom(k)) >= ^String.slice(val, 2..-1))
      "<=" -> where(query, [c], field(c,^String.to_atom(k)) <= ^String.slice(val, 2..-1))
    end
  end

  defp compose_query({k,val},query) do
    query
    |> where([c], field(c,^String.to_atom(k)) == ^val)
  end


end
