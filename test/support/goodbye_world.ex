defmodule EcholaliaTest.GoodbyeWorld.Behaviour do
  @type opts :: Keyword.t()
  @callback goodbye_world(opts) :: String.t()
  @callback goodbye_name(String.t(), opts) :: String.t()
end

defmodule EcholaliaTest.GoodbyeWorld.English do
  @behaviour EcholaliaTest.GoodbyeWorld.Behaviour

  @impl true
  def goodbye_world(_opts) do
    "Goodbye, world!"
  end

  @impl true
  def goodbye_name(name, _opts) do
    "Goodbye, #{name}!"
  end
end

defmodule EcholaliaTest.GoodbyeWorld.French do
  @behaviour EcholaliaTest.GoodbyeWorld.Behaviour

  @impl true
  def goodbye_world(_opts) do
    "Au revoir, le monde!"
  end

  @impl true
  def goodbye_name(name, _opts) do
    "Au revoir, #{name}!"
  end
end
