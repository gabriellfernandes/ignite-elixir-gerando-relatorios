defmodule GenReportTest do
  use ExUnit.Case

  alias GenReport
  alias GenReport.Support.ReportFixture

  @file_name "gen_report.csv"

  describe "build/1" do
    test "When passing file name return a report" do
      response = GenReport.build(@file_name)

      assert response == ReportFixture.build()
    end

    test "When no filename was given, returns an error" do
      response = GenReport.build()

      assert response == {:error, "Insira o nome de um arquivo"}
    end
  end

  describe "build_many/1" do
    test "When passing files names return a report" do
      response =
        GenReport.build_many(["gen_report_1.csv", "gen_report_2.csv", "gen_report_3.csv"])

      assert response == ReportFixture.build()
    end

    test "When no files names was given, returns an error" do
      response = GenReport.build_many("test")

      assert response == {:error, "Invalid list, plase send list strings"}
    end
  end
end
