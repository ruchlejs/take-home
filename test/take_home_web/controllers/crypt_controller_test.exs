defmodule CryptControllerTest do
  use TakeHomeWeb.ConnCase, async: true

  alias TakeHome.Crypto

  @secret_key "AAAA"

  describe "Post /encrypt" do
    test "valid encrypts in base64", %{conn: conn} do
      payload = %{
        "foo" => "foobar",
        "bar" => %{"isBar" => "true"}
      }

      res = conn |> post("/encrypt",payload) |>json_response(200)

      assert res["foo"] == Base.encode64("foobar")
      assert res["bar"] == Base.encode64(Jason.encode!(%{"isBar" => "true"}))

    end
  end


  describe "POST /decrypt" do
    test "valid decrypt in base64", %{conn: conn} do
      payload = %{
        "foo" => "Zm9vYmFy",
        "bar" => "eyJpc0JhciI6InRydWUifQ=="
      }

      res = conn |> post("/decrypt",payload) |> json_response(200)

      assert res["foo"] == "foobar"
      assert res["bar"] == %{"isBar" => "true"}
    end
  end


  describe "hmacSign/2" do
    test "returns different results for different keys" do
      test_key2 = "testKey2"

      test_payload = %{"test" => "test"}

      first_sign = Crypto.hmacSign(test_payload, @secret_key)
      second_sign = Crypto.hmacSign(test_payload, test_key2)

      refute first_sign == second_sign
    end

    test "returns the same result for the same payload and key" do

      test_payload = %{"test" => "test"}

      first_sign = Crypto.hmacSign(test_payload, @secret_key)
      second_sign = Crypto.hmacSign(test_payload, @secret_key)

      assert first_sign == second_sign
    end
  end


  describe "POST /sign" do
    test "valid sign" ,%{conn: conn} do
      payload = %{
        "test" => "I am testing the signing"
      }
      testSign = Crypto.hmacSign(payload,@secret_key)

      res = conn |> post("/sign", payload) |> json_response(200)

      assert res == testSign
    end
  end


  describe "POST /verify" do
    test "valid verification", %{conn: conn} do
      payload = %{
        "signature" => "5f9e5e168bdce1208b9d581d00b55d3afe8b8df016c9ca6de482ae1314d7263b",
        "data" => %{
          "test" => "I am testing the signing"
        }
      }

      res = conn |> post("/verify", payload)
      assert res.status == 204
    end

    test "missing signature", %{conn: conn} do
      payload = %{
        "data" => %{
          "test" => "I am testing the signing"
        }
      }

      res = conn |> post("/verify",payload) |> json_response(400)
      assert res["message"] == "You need to provide the signature and the data"
    end

    test "missing data", %{conn: conn} do
      payload = %{
        "signature" => "5f9e5e168bdce1208b9d581d00b55d3afe8b8df016c9ca6de482ae1314d7263b",
      }

      res = conn |> post("/verify",payload) |> json_response(400)
      assert res["message"] == "You need to provide the signature and the data"
    end

    test "wrong signature", %{conn: conn} do
      payload = %{
        "signature" => "wrongsign",
        "data" => %{
          "test" => "I am testing the signing"
        }
      }

      res = conn |> post("/verify",payload) |> json_response(400)
      assert res["message"] == "Invalid signature"
    end
  end
end
