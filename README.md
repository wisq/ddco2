# DDCO₂

DDCO₂ takes carbon dioxide and temperature readings from a CO₂Mini USB sensor (RAD-0301) and writes them to StatsD.

It acts as a very simple bridge between [ex_co2_mini](https://github.com/wisq/ex_co2_mini) (for reading from the device) and [statix](https://github.com/lexmag/statix) (for writing to StatsD).

Although designed and tested on [Datadog](https://www.datadoghq.com/), in theory, it should work fine on any StatsD server.

## Installation

1. Plug in the USB device to a Linux server.
    * Other OSes are not currently supported by ExCO₂Mini.
2. Get the corresponding `/dev/hidraw*` device set up.
    * You'll want it readable by the user you intend to monitor as.
    * See ["Device Setup"](https://github.com/wisq/ex_co2_mini#device-setup) from the ExCO₂Mini `README` for details.
3. Install [Elixir](https://elixir-lang.org/install.html).
4. Use git to clone this project somewhere.  (Change directory to that location.)
5. Copy `config/config.example.exs` to `config/config.exs` and change values as needed.
6. Run `mix deps.get`.
7. Run `mix compile`.

Now, you have two options on how to run DDCO₂:

* To get started, you can just run `mix ddco2`.  This will launch DDCO₂ right here and now, and begin logging results.
  * To exit, press control-C twice.
* If you're an experienced Elixir developer and/or sysadmin, and you want more flexibility, you can try deploying instead.
  * This is covered in [a separate document](docs/deploying.md).

## Legal stuff

Copyright © 2019, Adrian Irving-Beer.

DDCO₂ is released under the [Apache 2 License](../../blob/master/LICENSE) and is provided with **no warranty**.  This program is aimed at hobbyists and home enthusiasts, and should be used in **non-life-critical situations only**.
