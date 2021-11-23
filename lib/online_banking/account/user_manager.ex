defmodule OnlineBanking.Account.UserManager do
  @moduledoc """
  A module to handle state related to user
  """

  use GenServer
  alias OnlineBanking.Helpers.User

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl GenServer
  def init(users), do: {:ok, users}

  ###############################################################################
  #######################           Public APIs           #######################
  ###############################################################################
  def state(manager \\ __MODULE__) do
    GenServer.call(manager, :state)
  end

  def create_user(manager \\ __MODULE__, full_name, username, password) do
    GenServer.call(manager, {:create, full_name, username, password})
  end

  ###############################################################################
  #######################           Call handlers           #####################
  ###############################################################################
  @impl GenServer
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  @impl GenServer
  def handle_call({:create, full_name, username, password}, _from, state) do
    {_status, user, new_state} = User.create(state, full_name, username, password)

    {:reply, user, new_state}
  end
end
