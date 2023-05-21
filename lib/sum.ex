defmodule GenReport.Sum do
  def sum_values([name, hours, _day, month, year], %{
        "all_hours" => all_hours,
        "hours_per_month" => hours_per_month,
        "hours_per_year" => hours_per_year
      }) do
    all_hours = sum_values_all_hours(all_hours, name, hours)

    hours_per_month = sum_values_by_month(hours_per_month, name, month, hours)

    hours_per_year = sum_values_by_year(hours_per_year, name, year, hours)

    report_map(all_hours, hours_per_month, hours_per_year)
  end

  defp sum_values_all_hours(all_hours, name, hours) do
    Map.put(all_hours, name, all_hours[name] + hours)
  end

  defp sum_values_by_month(hours_per_month, name, month, hours) do
    Map.update(hours_per_month, name, 0, fn map ->
      Map.update(map, month, 0, fn value -> value + hours end)
    end)
  end

  defp sum_values_by_year(hours_per_year, name, year, hours) do
    Map.update(hours_per_year, name, 0, fn map ->
      Map.update(map, year, 0, fn value -> value + hours end)
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
