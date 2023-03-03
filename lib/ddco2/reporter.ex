defmodule DDCO2.Reporter do
  require Logger
  use GenServer

  alias ExCO2Mini.Collector

  defmodule State do
    @enforce_keys [:log_name, :collector]
    defstruct(
      log_name: nil,
      collector: nil
    )
  end

  @interval Application.get_env(:ddco2, :interval, 15_000)
  @prefix Application.get_env(:ddco2, :prefix, "co2mini")
  @tags Application.get_env(:ddco2, :tags, [])

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
    collector = state.collector
    Collector.temperature(collector) |> gauge("temperature")
    Collector.co2_ppm(collector) |> gauge("co2_ppm")

    {:noreply, state, @interval}
  end

  defp gauge(value, name) do
    gauge_key(value, with_prefix(name), @tags)
  end

  defp with_prefix(name) do
    @prefix <> "." <> name
  end

  defp gauge_key(nil, key) do
    Logger.info("Not recorded: #{key}")
  end

  defp gauge_key(value, key, []) do
    DDCO2.Statix.gauge(key, value)
    Logger.info("Recorded: #{key} = #{value}")
  end

  defp gauge_key(value, key, tags) when is_list(tags) do
    DDCO2.Statix.gauge(key, value, tags: tags)
    Logger.info("Recorded: #{key}#{inspect(tags)} = #{value}")
  end
end
