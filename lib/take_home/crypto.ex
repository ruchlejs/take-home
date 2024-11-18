defmodule TakeHome.Crypto do
  @encryption_type :base64


  def encrypt(value) do
    case @encryption_type do
      :base64 -> :base64.encode(value)
      _ -> raise "Unsupported encryption module"


    end
  end

  def decrypt(value) do
    case @encryption_type do
      :base64 ->
        decode = :base64.decode(value)
        case(Jason.decode(decode)) do
          {:ok,json} -> json
          _ -> decode
      _ -> raise "Unsupported encryption module"

     end
    end
  end

  def hmacSign(value, key) do
    :crypto.mac(:hmac,:sha256,key,Jason.encode!(value)) |> Base.encode16(case: :lower)
  end

end
