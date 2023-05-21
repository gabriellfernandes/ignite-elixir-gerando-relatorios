defmodule GenReport.CreateMap do
  def report_acc(file) do
    file
    |> Enum.reduce(init_map(), fn line, report -> create_report_acc(line, report) end)
  end

  defp create_report_all_hours(name, all_hours) do
    Map.put(all_hours, name, 0)
  end

  defp create_hours_per_month(name, hours_per_month) do
    Map.put(hours_per_month, name, %{
      "janeiro" => 0,
      "fevereiro" => 0,
      "março" => 0,
      "abril" => 0,
      "maio" => 0,
      "junho" => 0,
      "julho" => 0,
      "agosto" => 0,
      "setembro" => 0,
      "outubro" => 0,
      "novembro" => 0,
      "dezembro" => 0
    })
  end

  defp create_hours_per_year(name, hours_per_year) do
    Map.put(hours_per_year, name, %{
      2016 => 0,
      2017 => 0,
      2018 => 0,
      2019 => 0,
      2020 => 0
    })
  end

  defp create_report_acc([name, _hours, _day, _month, _year], report) do
    report_all_hours = create_report_all_hours(name, report["all_hours"])
    report_hours_per_month = create_hours_per_month(name, report["hours_per_month"])
    report_hours_per_year = create_hours_per_year(name, report["hours_per_year"])

    report_map(report_all_hours, report_hours_per_month, report_hours_per_year)
  end

  defp report_map(all_hours, hours_per_month, hours_per_year) do
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp init_map() do
    %{
      "all_hours" => %{},
      "hours_per_month" => %{},
      "hours_per_year" => %{}
    }
  end
end
