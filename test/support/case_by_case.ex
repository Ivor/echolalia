defmodule EcholaliaTest.CaseByCase.Behaviour do
  @type opts :: Keyword.t()
  @callback upcase(string :: String.t(), opts) :: String.t()
  @callback downcase(string :: String.t(), opts) :: String.t()
end

defmodule EcholaliaTest.CaseByCase do
  use Echolalia.CatchAll,
    behaviour: EcholaliaTest.CaseByCase.Behaviour,
    impl: &EcholaliaTest.CaseByCase.handle_case_by_case/2

  # NOTE: Doing string manipulation in parallel like this is very unlikely to
  # be faster than doing it in a single process. This is just an example of
  # how the catch_all option can be used.
  def handle_case_by_case(:upcase, [string, opts]) do
    if Keyword.get(opts, :concurrent) do
      String.graphemes(string)
      |> concurrent_conversion(&String.upcase/1)
      |> Enum.join()
    else
      String.upcase(string)
    end
  end

  def handle_case_by_case(:downcase, [string, opts]) do
    if Keyword.get(opts, :concurrent) do
      String.graphemes(string)
      |> concurrent_conversion(&String.downcase/1)
      |> Enum.join()
    else
      String.downcase(string)
    end
  end

  defp concurrent_conversion(enum, conversion_fn) do
    Enum.map(enum, fn el ->
      Task.async(fn ->
        conversion_fn.(el)
      end)
    end)
    |> Task.await_many()
  end
end
