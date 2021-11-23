defmodule OnlineBanking.Helpers.User do
  @moduledoc """
  A helper module for schema and logic
  """

  @enforce_keys ~w(full_name user_name password account)a
  alias OnlineBanking.Helpers.Account

  defstruct full_name: nil,
            user_name: nil,
            password: nil,
            account: %{}

  def create(state, full_name, username, password) do
    fields = %{
      full_name: full_name,
      user_name: username,
      password: password,
      account: Account.create_account(username)
    }

    user = struct!(__MODULE__, fields)

    {:ok, user, [user | state]}
  end
end
