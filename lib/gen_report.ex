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

  def build_many(file_names) when not is_list(file_names) do
    {:error, "Invalid list, plase send list strings"}
  end

  def build_many(file_names) do
    file_names
    |> Task.async_stream(&build/1)
    |> Enum.reduce(report_map(%{}, %{}, %{}), fn {:ok, result}, report ->
      Sum.sum_reports(report, result)
    end)
  end

  defp report_map(all_hours, hours_per_month, hours_per_year) do
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end
end
