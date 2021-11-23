defmodule OnlineBanking do
  @moduledoc """
  OnlineBanking keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias OnlineBanking.Account.UserManager
  alias OnlineBanking.Account.TransactionManager
  alias OnlineBanking.Helpers.User

  def create_user(full_name, user_name, password) do
    with all_users <- UserManager.state(),
         nil <- user_name_exist(all_users, user_name),
         full_name <- String.capitalize(full_name),
         user <- UserManager.create_user(full_name, user_name, password) do

      {:ok, user}
    else
      %User{} -> {:error, "Username already exist"}
    end
  end

  def get_user_by_account_number(account_number) do
    with all_users <- UserManager.state(),
         [user] <- Enum.filter(all_users, &(&1.account.account_number == account_number)),
         user <- add_transactions(user) do
      {:ok, user}
    else
      [] -> {:error, "Invalid account number"}
    end
  end

  def get_user_by_username(user_name) do
    with all_users <- UserManager.state(),
         [user] <- Enum.filter(all_users, &(&1.user_name == user_name)),
         user <- add_transactions(user) do
      {:ok, user}
    else
      [] -> {:error, "Invalid account number"}
    end
  end

  def deposit_money(account_number, amount) do
    with :valid_account <- validate_account_number(account_number),
         :valid_amount <- validate_amount(amount),
         _transactions <- TransactionManager.new(account_number, amount, :withdrawal) do
      {:ok, :success}
    else
      :invalid_account -> {:error, "Account number does not exist"}
      :invalid_amount -> {:error, "Invalid amount or type"}
    end
  end

  def withdrawal_money(account_number, amount) do
    with :valid_account <- validate_account_number(account_number),
         :valid_amount <- validate_amount(amount),
         _transactions <- TransactionManager.new(account_number, amount, :withdrawal) do
      {:ok, :success}
    else
      :invalid_account -> {:error, "Account number does not exist"}
      :invalid_amount -> {:error, "Invalid amount or type"}
    end
  end

  defp user_name_exist(all_users, user_name),
    do: Enum.find(all_users, &(&1.user_name == user_name))

  defp validate_account_number(account_number) do
    UserManager.state()
    |> Enum.find(&(&1.account.account_number == account_number))
    |> case do
      nil -> :invalid_account
      %OnlineBanking.Helpers.User{} -> :valid_account
    end
  end

  defp validate_amount(amount) when is_integer(amount), do: :valid_amount
  defp validate_amount(amount) when is_float(amount), do: :valid_amount
  defp validate_amount(_), do: :invalid_amount

  defp add_transactions(user) do
    user_transactions =
      Enum.filter(TransactionManager.state(), &(&1.account_number == user.account.account_number))

    Map.get_and_update(user, :account, fn curr_val ->
      {curr_val, Map.put(curr_val, :transactions, user_transactions)}
    end)
    |> elem(1)
  end
end
