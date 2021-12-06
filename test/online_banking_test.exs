defmodule OnlineBankingTest do
  use ExUnit.Case
  doctest OnlineBanking

  setup [:account_creation_params, :clear_on_exit]

  describe "OnlineBanking.create_user/3" do
    test "Success - When user data provided correctly", %{
      full_name: full_name,
      user_name: user_name,
      password: password
    } do
      assert {:ok,
              %OnlineBanking.Helpers.User{
                transactions: transactions,
                balance: balance,
                account_number: account_number
              }} = OnlineBanking.create_user(full_name, user_name, password)

      assert is_list(transactions)
      assert is_float(balance)
      assert is_integer(account_number)
    end

    test "Error - When user already exist", %{
      full_name: full_name,
      user_name: user_name,
      password: password
    } do
      assert {:ok, %OnlineBanking.Helpers.User{}} =
               OnlineBanking.create_user(full_name, user_name, password)

      assert {:error, "Username already exist"} ==
               OnlineBanking.create_user(full_name, user_name, password)
    end
  end

  describe "OnlineBanking.get_user_details_by_account_number/1" do
    test "Success - When correct account number is given", %{
      full_name: full_name,
      user_name: user_name,
      password: password
    } do
      {:ok, %OnlineBanking.Helpers.User{account_number: account_number}} =
        OnlineBanking.create_user(full_name, user_name, password)

      assert {:ok, %OnlineBanking.Helpers.User{}} =
               OnlineBanking.get_user_details_by_account_number(account_number)
    end

    test "Error - When incorrect account number is given" do
      # set up
      account_number = 1_111_111_111

      assert {:error, "Invalid account number"} ==
               OnlineBanking.get_user_details_by_account_number(account_number)
    end
  end

  describe "OnlineBanking.get_user_details_by_username/1" do
    test "Success - When correct username is given", %{
      full_name: full_name,
      user_name: user_name,
      password: password
    } do
      {:ok, %OnlineBanking.Helpers.User{user_name: user_name}} =
        OnlineBanking.create_user(full_name, user_name, password)

      assert {:ok, %OnlineBanking.Helpers.User{}} =
               OnlineBanking.get_user_details_by_username(user_name)
    end

    test "Error - When incorrect username is given" do
      # set up
      username = "dummy_user"
      assert {:error, "Invalid username"} == OnlineBanking.get_user_details_by_username(username)
    end
  end

  describe "OnlineBanking.deposit_money/2" do
    test "Success - When correct amount is given", %{
      full_name: full_name,
      user_name: user_name,
      password: password
    } do
      {:ok, current_user} = OnlineBanking.create_user(full_name, user_name, password)

      assert {:ok, current_user} = OnlineBanking.deposit_money("101.0", current_user)
      assert current_user.balance == 101.0

      assert {:ok, current_user} = OnlineBanking.deposit_money("100", current_user)
      assert current_user.balance == 201.0
    end

    test "Error - When incorrect amount is given", %{
      full_name: full_name,
      user_name: user_name,
      password: password
    } do
      {:ok, current_user} = OnlineBanking.create_user(full_name, user_name, password)

      assert {:error, "Invalid amount or type"} ==
               OnlineBanking.deposit_money("abc", current_user)
    end
  end

  describe "OnlineBanking.withdraw_money/2" do
    test "Success - When correct amount is given", %{
      full_name: full_name,
      user_name: user_name,
      password: password
    } do
      {:ok, current_user} = OnlineBanking.create_user(full_name, user_name, password)
      {:ok, current_user} = OnlineBanking.deposit_money("200", current_user)
      assert current_user.balance == 200.0

      assert {:ok, current_user} = OnlineBanking.withdraw_money("99", current_user)
      assert current_user.balance == 101.0

      assert {:ok, current_user} = OnlineBanking.withdraw_money("100", current_user)
      assert current_user.balance == 1.0
    end

    test "Error - When incorrect amount is given", %{
      full_name: full_name,
      user_name: user_name,
      password: password
    } do
      {:ok, current_user} = OnlineBanking.create_user(full_name, user_name, password)

      assert {:error, "Invalid amount or type"} ==
               OnlineBanking.withdraw_money("abc", current_user)
    end

    test "Error - When amount is higher than available balance", %{
      full_name: full_name,
      user_name: user_name,
      password: password
    } do
      {:ok, current_user} = OnlineBanking.create_user(full_name, user_name, password)
      {:ok, current_user} = OnlineBanking.deposit_money("200", current_user)
      assert {:error, "Insufficient balance"} == OnlineBanking.withdraw_money("500", current_user)

      {:ok, current_user} = OnlineBanking.withdraw_money("100", current_user)
      assert {:error, "Insufficient balance"} == OnlineBanking.withdraw_money("101", current_user)
    end
  end

  defp account_creation_params(context) do
    user_params = %{
      full_name: "Nitesh Mishra",
      user_name: "nitesh_007",
      password: "Nitesh@123"
    }

    {:ok, Map.merge(context, user_params)}
  end

  defp clear_on_exit(context) do
    {_, {_, pid}} = OnlineBanking.Account.UserManager.start_link()
    :sys.replace_state(pid, fn _state -> [] end)
  end
end
