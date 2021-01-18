defmodule StaleAssoc do
  alias StaleAssoc.User
  alias StaleAssoc.Repo

  import Ecto.Query

  def setup_user do
    %User{}
    |> User.changeset(%{
      email: "foo@example.com",
      permissions: [
        %{scope: "posts", actions: ["create", "read", "update", "delete"], user_id: nil}
      ]
    })
    |> Repo.insert!()
  end

  @doc """
  With `on_replace: :delete` option on the `permissions` assoc for `user` we see
  `Ecto.StaleEntryError` due to the race between two updates i.e. one update deletes the
  permissions before the other:

  ```elixir
  14:03:41.770 [error] Task #PID<0.277.0> started from #PID<0.248.0> terminating
  ** (Ecto.StaleEntryError) attempted to delete a stale struct:

  %StaleAssoc.Permission{__meta__: #Ecto.Schema.Metadata<:loaded, "permissions">, actions: ["read"], id: "a103a831-34fb-4834-8e43-95eb5745170d", scope: "posts", user: #Ecto.Association.NotLoaded<association :user is not loaded>, user_id: "c23a5082-a209-49d9-a725-1dcc3e95a8c6"}

      (ecto 3.5.5) lib/ecto/repo/schema.ex:666: Ecto.Repo.Schema.apply/4
      (ecto 3.5.5) lib/ecto/repo/schema.ex:437: anonymous fn/10 in Ecto.Repo.Schema.do_delete/4
      (ecto 3.5.5) lib/ecto/association.ex:706: Ecto.Association.Has.on_repo_change/5
      (ecto 3.5.5) lib/ecto/association.ex:692: Ecto.Association.Has.on_repo_change/5
      (ecto 3.5.5) lib/ecto/association.ex:476: anonymous fn/8 in Ecto.Association.on_repo_change/7
      (elixir 1.11.1) lib/enum.ex:2181: Enum."-reduce/3-lists^foldl/2-0-"/3
      (ecto 3.5.5) lib/ecto/association.ex:472: Ecto.Association.on_repo_change/7
      (elixir 1.11.1) lib/enum.ex:2181: Enum."-reduce/3-lists^foldl/2-0-"/3
  Function: #Function<1.7707114/0 in StaleAssoc.update_user/0>
      Args: []
  ```

  One may expect the update to happen idempotently with this option, or to allow configuration
  for such behaviour.
  """
  def update_user do
    Task.start(fn ->
      from(u in User, where: u.email == "foo@example.com", preload: [:permissions])
      |> Repo.one!()
      |> User.changeset(%{
        permissions: [
          %{scope: "posts", actions: []}
        ]
      })
      |> Repo.update!()
    end)

    Task.start(fn ->
      from(u in User, where: u.email == "foo@example.com", preload: [:permissions])
      |> Repo.one!()
      |> User.changeset(%{
        permissions: [
          %{scope: "posts", actions: ["read"]}
        ]
      })
      |> Repo.update!()
    end)
  end
end
