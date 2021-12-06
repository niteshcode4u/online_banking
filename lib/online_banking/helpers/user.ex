defmodule OnlineBanking.Helpers.User do
  @moduledoc """
  A helper module for schema and logic
  """

  @enforce_keys ~w(full_name user_name password account_number balance transactions)a

  defstruct full_name: nil,
            user_name: nil,
            password: nil,
            account_number: nil,
            balance: nil,
            transactions: []

  def create(state, full_name, username, password) do
    fields = %{
      full_name: full_name,
      user_name: username,
      password: password,
      account_number: Enum.random(11_111..99_999),
      balance: 0.0,
      transactions: []
    }

    user = struct!(__MODULE__, fields)

    {:ok, user, [user | state]}
  end

  def update_balance(all_users, operation, amount, account_number) do
    current_user =
      all_users
      |> Enum.find(fn user -> user.account_number == account_number end)
      |> update_account_balance(amount, operation)

    other_users = Enum.filter(all_users, fn user -> user.account_number != account_number end)
    # user = Map.merge(user_data, %{account: update_account})

    {:ok, current_user, [current_user | other_users]}
  end

  defp update_account_balance(user_account, amount, :deposit),
    do: %{user_account | balance: user_account.balance + amount}

  defp update_account_balance(user_account, amount, :withdraw),
    do: %{user_account | balance: user_account.balance - amount}
end
