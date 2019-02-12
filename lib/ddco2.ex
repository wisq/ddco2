defmodule DDCO2 do
  require Logger
  use Application

  @children [
    {ExCO2Mini.Reader,
     [
       name: DDCO2.Reader,
       subscribers: [DDCO2.Collector],
       send_from_name: true,
       device: "/dev/co2mini"
     ]},
    {ExCO2Mini.Collector,
     [
       name: DDCO2.Collector,
       reader: DDCO2.Reader,
       subscribe_as_name: true
     ]},
    {DDCO2.Reporter,
     [
       name: DDCO2.Reporter,
       collector: DDCO2.Collector
     ]}
  ]

  def start(_type, _args) do
    Logger.info("DDCO2 starting ...")
    :ok = DDCO2.Statix.connect()

    Supervisor.start_link(
      @children,
      strategy: :one_for_one,
      name: DynChan.Supervisor
    )
  end
end
