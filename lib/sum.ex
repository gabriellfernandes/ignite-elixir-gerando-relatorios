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

  def sum_reports(
        %{
          "all_hours" => all_hours1,
          "hours_per_month" => hours_per_month1,
          "hours_per_year" => hours_per_year1
        },
        %{
          "all_hours" => all_hours2,
          "hours_per_month" => hours_per_month2,
          "hours_per_year" => hours_per_year2
        }
      ) do
    all_hours = margin_maps_without_map(all_hours1, all_hours2)
    hours_per_month = margin_maps_with_map(hours_per_month1, hours_per_month2)
    hours_per_year = margin_maps_with_map(hours_per_year1, hours_per_year2)

    report_map(all_hours, hours_per_month, hours_per_year)
  end

  defp margin_maps_with_map(map1, map2) do
    case map_size(map1) do
      0 ->
        map2

      _ ->
        Enum.reduce(map1, %{}, fn {name, months}, acc ->
          month_values =
            Enum.reduce(months, %{}, fn {month, hours}, acc2 ->
              Map.put(acc2, month, hours + map2[name][month])
            end)

          Map.put(acc, name, month_values)
        end)
    end
  end

  defp margin_maps_without_map(map1, map2) do
    case map_size(map1) do
      0 ->
        map2

      _ ->
        Enum.reduce(map1, %{}, fn {key, value}, acc ->
          case Map.get(map2, key) do
            nil -> acc
            other_value -> Map.put(acc, key, value + other_value)
          end
        end)
    end
  end

  defp report_map(all_hours, hours_per_month, hours_per_year) do
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end
end
