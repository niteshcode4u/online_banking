defmodule OnlineBanking.Account.TransactionManager do
  @moduledoc """
  A module to handle state related to user
  """

  use GenServer
  alias OnlineBanking.Helpers.Transaction

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl GenServer
  def init(accounts), do: {:ok, accounts}

  ###############################################################################
  #######################           Public APIs           #######################
  ###############################################################################
  def state(manager \\ __MODULE__) do
    GenServer.call(manager, :state)
  end

  def new(manager \\ __MODULE__, account_no, amount, transaction_type) do
    GenServer.call(manager, {:new, account_no, amount, transaction_type})
  end

  ###############################################################################
  #######################           Call handlers           #####################
  ###############################################################################
  @impl GenServer
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  @impl GenServer
  def handle_call({:new, account_no, amount, transaction_type}, _from, state) do
    new_state = Transaction.new(state, account_no, amount, transaction_type)

    {:reply, new_state, new_state}
  end
end
