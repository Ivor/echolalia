defmodule EcholaliaTest.ImplAsFunctionTest do
  use ExUnit.Case

  defmodule HelloWorld do
    use Echolalia,
      behaviour: EcholaliaTest.HelloWorld.Behaviour,
      impl: &HelloWorld.get_hello_implementation/1

    use Echolalia,
      behaviour: EcholaliaTest.GoodbyeWorld.Behaviour,
      impl: &HelloWorld.get_goodbye_implementation/1

    def get_hello_implementation([opts]),
      do: lang_implementation(:hello, Keyword.fetch!(opts, :language))

    def get_hello_implementation([_name, opts]),
      do: lang_implementation(:hello, Keyword.fetch!(opts, :language))

    def get_goodbye_implementation([opts]),
      do: lang_implementation(:goodbye, Keyword.fetch!(opts, :language))

    def get_goodbye_implementation([_name, opts]),
      do: lang_implementation(:goodbye, Keyword.fetch!(opts, :language))

    defp lang_implementation(behaviour, language) do
      case {behaviour, language} do
        {:hello, :english} -> EcholaliaTest.HelloWorld.English
        {:hello, :french} -> EcholaliaTest.HelloWorld.French
        {:goodbye, :english} -> EcholaliaTest.GoodbyeWorld.English
        {:goodbye, :french} -> EcholaliaTest.GoodbyeWorld.French
      end
    end
  end

  test "HelloWorld implements the EcholaliaTest.HelloWorld.Behaviour behaviour" do
    assert HelloWorld.hello_world(language: :english) == "Hello, world!"
    assert HelloWorld.hello_world(language: :french) == "Bonjour, le monde!"

    assert HelloWorld.hello_name("Bob", language: :english) == "Hello, Bob!"
    assert HelloWorld.hello_name("Bob", language: :french) == "Bonjour, Bob!"

    assert HelloWorld.how_are_you(language: :english) == "How are you?"
    assert HelloWorld.how_are_you(language: :french) == "Comment allez-vous?"

    assert HelloWorld.how_are_you_name("Bob", language: :english) == "How are you, Bob?"
    assert HelloWorld.how_are_you_name("Bob", language: :french) == "Comment allez-vous, Bob?"
  end

  test "HelloWorld implements the EcholaliaTest.GoodbyeWorld.Behaviour behaviour" do
    assert HelloWorld.goodbye_world(language: :english) == "Goodbye, world!"
    assert HelloWorld.goodbye_world(language: :french) == "Au revoir, le monde!"

    assert HelloWorld.goodbye_name("Bob", language: :english) == "Goodbye, Bob!"
    assert HelloWorld.goodbye_name("Bob", language: :french) == "Au revoir, Bob!"
  end
end
