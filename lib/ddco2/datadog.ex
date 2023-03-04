defmodule DDCO2.Datadog do
  require Logger

  @prefix Application.get_env(:ddco2, :prefix, "co2mini")
  @tags Application.get_env(:ddco2, :tags, [])

  def child_spec(opts) do
    %{id: __MODULE__, start: {__MODULE__, :start_link, [opts]}}
  end

  def start_link(opts) do
    opts = Keyword.put(opts, :name, __MODULE__)
    DogStatsd.start_link(%{}, opts)
  end

  def record(metrics) do
    DogStatsd.batch(__MODULE__, fn batch ->
      Enum.each(metrics, &send_to_datadog(&1, batch))
    end)

    Logger.info("Recorded #{Enum.count(metrics)} metrics.")
    :ok
  end

  defp send_to_datadog({suffix, value}, batch) do
    key = prefix_key(@prefix, suffix)
    Logger.info("Recording: #{key}#{inspect(@tags)} = #{value}")
    batch.gauge(__MODULE__, key, value, tags: @tags)
  end

  defp prefix_key(nil, key), do: key
  defp prefix_key("", key), do: key
  defp prefix_key(prefix, key), do: "#{prefix}.#{key}"
end
