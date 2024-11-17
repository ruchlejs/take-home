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
    json(conn,%{message: "sign"})
  end

  def verify(conn,_params) do
    json(conn,%{message: "verify"})
  end
end
