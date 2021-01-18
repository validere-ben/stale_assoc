defmodule StaleAssoc.Repo.Migrations.AddSchemas do
  use Ecto.Migration

  def up do
    create table(:users, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:email, :string, null: false)
    end

    create(unique_index(:users, [:email]))

    create table(:permissions, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:scope, :string, null: false)
      add(:actions, {:array, :string}, null: false, default: [])
      add(:user_id, references(:users, on_delete: :delete_all, type: :uuid), null: false)
    end

    create(unique_index(:permissions, [:scope, :user_id]))
  end

  def down do
    drop(table(:permissions))
    drop(table(:users))
  end
end
