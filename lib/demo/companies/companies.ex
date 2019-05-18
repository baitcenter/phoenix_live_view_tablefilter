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

end
