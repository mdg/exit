defmodule Exit.MixProject do
  use Mix.Project

  def project do
    [
      app: :exit,
      version: "0.3.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: [
        maintainers: ["Matthew Graham"],
        description: "A set of common utility functions for iterating enumerables",
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/mdg/exit"},
      ],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.4", only: :dev, runtime: false},
      {:ex_doc, "~> 0.32", only: :dev, runtime: false},
      {:freedom_formatter, "~> 2.1", only: [:dev, :test], runtime: false},
    ]
  end
end
