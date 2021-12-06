defmodule OnlineBanking.Helpers.Transaction do
  @type t :: %__MODULE__{}
  @enforce_keys ~w(account_number amount transction_type entry_time)a

  defstruct account_number: nil,
            amount: nil,
            transction_type: nil,
            entry_time: nil

  def new(state, account_number, amount, transction_type) do
    fields = %{
      account_number: account_number,
      amount: amount,
      transction_type: transction_type,
      entry_time: add_timestamp()
    }

    OnlineBanking.Account.UserManager.update_balance(transction_type, amount, account_number)

    [struct!(__MODULE__, fields) | state]
  end

  defp add_timestamp(), do: to_string(DateTime.utc_now())
end
