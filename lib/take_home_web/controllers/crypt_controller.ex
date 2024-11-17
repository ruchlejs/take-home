defmodule TakeHomeWeb.CryptController do
  use TakeHomeWeb, :controller

  alias TakeHome.Crypto

  def encrypt(conn, _params) do
    encode = Map.new(conn.body_params, fn({key, value}) ->
      if is_binary(value) do
        IO.inspect(value)
        {key,Crypto.encrypt(value)}
      else
        IO.inspect(value)
        {key,Crypto.encrypt(Jason.encode!(value))}
      end
    end)
    json(conn,encode)
  end

  def decrypt(conn,_params) do
    decode = Map.new(conn.body_params, fn({key,value}) ->
      {key,Crypto.decrypt(value)}
    end)
    IO.puts("sorti decode")
    IO.inspect(decode)
    json(conn,decode)
  end

  def sign(conn,_params) do
    secretKey = "AAAA"
    hmac = :crypto.mac(:hmac,:sha256,secretKey,Jason.encode!(conn.body_params)) |> Base.encode16(case: :lower)
    json(conn,hmac)
  end

  def verify(conn,_params) do
    body = conn.body_params
    if Map.has_key?(body,"signature") && Map.has_key?(body,"data") do
      providedSign = body["signature"]
      # IO.inspect(providedSign)

      secretKey = "AAAA"
      hmac = :crypto.mac(:hmac,:sha256,secretKey,Jason.encode!(body["data"])) |> Base.encode16(case: :lower)

      if hmac === providedSign do

        json(conn,%{message: "same"})
      else
        json(conn,%{message: "different #{hmac}"})
      end

    else
      json(conn,%{message: "You need to provide the signature and the data"})
    end

  end
end
