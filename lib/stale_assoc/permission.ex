defmodule StaleAssoc.Permission do
  use Ecto.Schema

  alias StaleAssoc.User

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @fields [:scope, :actions, :user_id]

  @scopes ["posts"]
  @actions ["create", "read", "update", "delete"]

  schema "permissions" do
    field(:scope, :string)
    field(:actions, {:array, :string})

    belongs_to(:user, User)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_inclusion(:scope, @scopes)
    |> validate_subset(:actions, @actions)
  end
end
