defmodule Demo.Companies do
   @moduledoc """
  The Companies context.
  """

  import Ecto.Query, warn: false

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

  defp compose_query({"search", name}, query) do
    string = "%" <> name <> "%"
    where(query, [d], like(d.user_name, ^string))
  end

  defp compose_query( { k, {op , val} } = _filter ,query) do
    case op do
      "=" ->
        string = "%" <> val <> "%"
        where(query, [d], like( field(d,^String.to_atom(k)) , ^string))
      ">" -> where(query, [d], field(d,^String.to_atom(k)) > ^String.slice(val, 1..-1))
      "<" -> where(query, [d], field(d,^String.to_atom(k)) < ^String.slice(val, 1..-1))
      ">=" -> where(query, [d], field(d,^String.to_atom(k)) >= ^String.slice(val, 2..-1))
      "<=" -> where(query, [d], field(d,^String.to_atom(k)) <= ^String.slice(val, 2..-1))
    end
  end

  defp compose_query({k,val},query) do
    query
    |> where([c], field(c,^String.to_atom(k)) == ^val)
  end

end
