defmodule Demo.Companies.Customer do
  use Ecto.Schema
  #import Ecto.Changeset

  schema "customers" do
    field :customerName, :string
    field :contactLastName, :string
    field :contactFirstName, :string
    field :phone, :string
    field :addressLine1, :string
    field :addressLine2, :string
    field :city, :string
    field :state, :string
    field :postalCode, :string
    field :country, :string
    field :creditLimit, :decimal
  end

end
