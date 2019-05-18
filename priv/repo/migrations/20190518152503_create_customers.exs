defmodule Demo.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add(:customerName, :string)
      add(:contactLastName, :string)
      add(:contactFirstName, :string)
      add(:phone, :string)
      add(:addressLine1, :string)
      add(:addressLine2, :string)
      add(:city, :string)
      add(:state, :string)
      add(:postalCode, :string)
      add(:country, :string)
      add(:creditLimit, :decimal)

    end

  end
end
