defmodule Mix.Tasks.Ddco2 do
  use Mix.Task

  @shortdoc "Run DDCO₂"

  def run([]) do
    {:ok, _} = Application.ensure_all_started(:ddco2, :permanent)
    Process.sleep(:infinity)
  end

  def run(_) do
    Mix.raise("Usage:  mix ddco2  (no arguments)")
  end
end
