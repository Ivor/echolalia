Mox.defmock(EcholaliaTest.Arithmetic.MultiplyMock, for: EcholaliaTest.Arithmetic.MultiplyBehaviour)

Application.put_env(:echolalia, :multiply_impl, EcholaliaTest.Arithmetic.MultiplyMock)

ExUnit.start()
