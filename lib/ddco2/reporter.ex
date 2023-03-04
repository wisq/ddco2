defmodule DDCO2.Reporter do
  require Logger
  use GenServer

  alias ExCO2Mini.Collector
  alias DDCO2.Datadog

  defmodule State do
    @enforce_keys [:log_name, :collector]
    defstruct(
      log_name: nil,
      collector: nil
    )
  end

  @interval Application.get_env(:ddco2, :interval, 15_000)

  def start_link(opts) do
    collector = Keyword.fetch!(opts, :collector)

    log_name =
      Keyword.get(opts, :name, __MODULE__)
      |> Atom.to_string()
      |> String.replace("Elixir.", "")

    GenServer.start_link(__MODULE__, {collector, log_name}, opts)
  end

  @impl true
  def init({collector, log_name}) do
    state = %State{
      log_name: log_name,
      collector: collector
    }

    Logger.info("#{state.log_name} started.")
    {:ok, state, @interval}
  end

  @impl true
  def handle_info(:timeout, state) do
    metrics(state.collector)
    |> Enum.filter(&record_metric?/1)
    |> Datadog.record()

    {:noreply, state, @interval}
  end

  defp metrics(collector) do
    [
      temperature: Collector.temperature(collector),
      co2_ppm: Collector.co2_ppm(collector)
    ]
  end

  defp record_metric?({_key, nil}), do: false
  defp record_metric?({_key, _value}), do: true
end
