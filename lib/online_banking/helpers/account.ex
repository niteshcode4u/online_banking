defmodule OnlineBanking.Helpers.Account do
  @enforce_keys ~w(account_number balance transactions)a
  defstruct account_number: nil,
            username: nil,
            balance: nil,
            transactions: []

  def create_account(username) do
    fields = %{
      account_number: Enum.random(11111..99999),
      username: username,
      balance: 0,
      transactions: []
    }

    struct!(__MODULE__, fields)
  end
end
