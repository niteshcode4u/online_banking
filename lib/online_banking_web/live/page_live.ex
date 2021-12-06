defmodule OnlineBankingWeb.PageLive do
  use OnlineBankingWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, assign(socket, current_user: nil)}
  end

  @impl Phoenix.LiveView
  def handle_event("sign_in", user_credentials, socket) do
    socket = clear_flash(socket)

    OnlineBanking.user_credentials()
    |> Enum.filter(fn user_cred ->
      user_cred.password == user_credentials["password"] and
        user_cred.user_name == user_credentials["username"]
    end)
    |> case do
      [] ->
        {:noreply, put_flash(socket, :error, "Invalid credentials")}

      [curr_user] ->
        {:ok, user_details} = OnlineBanking.get_user_details_by_username(curr_user.user_name)

        {:noreply, assign(socket, current_user: user_details)}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("sign_out", _, socket) do
    {:noreply, assign(socket, current_user: nil)}
  end

  @impl Phoenix.LiveView
  def handle_event("deposit", %{"deposit_amount" => amount}, socket) do
    socket = clear_flash(socket)

    case OnlineBanking.deposit_money(amount, socket.assigns.current_user) do
      {:ok, curr_user} -> {:noreply, assign(socket, current_user: curr_user)}
      {:error, error} -> {:noreply, put_flash(socket, :error, error)}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("withdraw", %{"withdraw_amount" => amount}, socket) do
    socket = clear_flash(socket)

    case OnlineBanking.withdraw_money(amount, socket.assigns.current_user) do
      {:ok, curr_user} -> {:noreply, assign(socket, current_user: curr_user)}
      {:error, error} -> {:noreply, put_flash(socket, :error, error)}
    end
  end
end
