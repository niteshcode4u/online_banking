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

  @doc """
    we need to create user using this function as a manual process in bank to create an account

        Example

        iex> OnlineBanking.create_user("nitesh mishra", "nitesh", "password")
        {:ok,
          %OnlineBanking.Helpers.User{
            account_number: 40106,
            balance: 0.0,
            full_name: "Nitesh mishra",
            password: "password",
            transactions: [],
            user_name: "nitesh"
          }}
  """

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

  def user_credentials(),
    do:
      Enum.map(UserManager.state(), fn user ->
        %{user_name: user.user_name, password: user.password}
      end)

  def get_user_details_by_account_number(account_number) do
    with all_users <- UserManager.state(),
         [user] <- Enum.filter(all_users, &(&1.account_number == account_number)),
         user <- add_transactions(user) do
      {:ok, user}
    else
      [] -> {:error, "Invalid username"}
    end
  end

  def get_user_details_by_username(user_name) do
    with all_users <- UserManager.state(),
         [user] <- Enum.filter(all_users, &(&1.user_name == user_name)),
         user <- add_transactions(user) do
      {:ok, user}
    else
      [] -> {:error, "Invalid account number"}
    end
  end

  def deposit_money(amount, current_user) do
    current_user.account_number
    |> TransactionManager.new(amount, :deposit)
    |> List.first()
    |> get_updated_current_user()
  end

  def withdraw_money(amount, current_user) do
    case current_user.balance >= amount do
      true ->
        current_user.account_number
        |> TransactionManager.new(amount, :withdraw)
        |> List.first()
        |> get_updated_current_user()

      false ->
        {:error, "Insufficient balance"}
    end
  end

  defp get_updated_current_user(transaction),
    do: get_user_details_by_account_number(transaction.account_number)

  defp user_name_exist(all_users, user_name),
    do: Enum.find(all_users, &(&1.user_name == user_name))

  defp add_transactions(current_user) do
    user_transactions =
      Enum.filter(TransactionManager.state(), &(&1.account_number == current_user.account_number))

    Map.put(current_user, :transactions, user_transactions)
  end
end
