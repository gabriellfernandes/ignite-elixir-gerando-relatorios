defmodule GenReport do
  alias GenReport.CreateMap
  alias GenReport.Parser
  alias GenReport.Sum

  def build(file_name) do
    file =
      file_name
      |> Parser.parse_file()

    file
    |> Enum.reduce(CreateMap.report_acc(file), fn line, report -> Sum.sum_values(line, report) end)
  end

  def build() do
    {:error, "Insira o nome de um arquivo"}
  end

  defp report_map(all_hours, hours_per_month, hours_per_year) do
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end
end
