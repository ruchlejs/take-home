defmodule TakeHome.Crypto do
  def encrypt(value) do
    :base64.encode(value)
  end

  def decrypt(value) do
    decode = :base64.decode(value)
    case(Jason.decode(decode)) do
      {:ok,json} -> json
      _ -> decode

    end
  end

  def hmacSign(value, key) do
    :crypto.mac(:hmac,:sha256,key,Jason.encode!(value)) |> Base.encode16(case: :lower)
  end


end
