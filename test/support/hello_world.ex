defmodule EcholaliaTest.HelloWorld.Behaviour do
  @type opts :: Keyword.t()
  @callback hello_world(opts) :: String.t()
  @callback hello_name(String.t(), opts) :: String.t()
  @callback how_are_you(opts) :: String.t()
  @callback how_are_you_name(String.t(), opts) :: String.t()
end

defmodule EcholaliaTest.HelloWorld.EnglishImpl do
  @behaviour EcholaliaTest.HelloWorld.Behaviour

  @impl true
  def hello_world(_opts) do
    "Hello, world!"
  end

  @impl true
  def hello_name(name, _opts) do
    "Hello, #{name}!"
  end

  @impl true
  def how_are_you(_opts) do
    "How are you?"
  end

  @impl true
  def how_are_you_name(name, _opts) do
    "How are you, #{name}?"
  end
end

defmodule EcholaliaTest.HelloWorld.FrenchImpl do
  @behaviour EcholaliaTest.HelloWorld.Behaviour

  @impl true
  def hello_world(_opts) do
    "Bonjour, le monde!"
  end

  @impl true
  def hello_name(name, _opts) do
    "Bonjour, #{name}!"
  end

  @impl true
  def how_are_you(_opts) do
    "Comment allez-vous?"
  end

  @impl true
  def how_are_you_name(name, _opts) do
    "Comment allez-vous, #{name}?"
  end
end
