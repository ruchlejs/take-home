defmodule TakeHomeWeb.CryptController do
  use TakeHomeWeb, :controller

  alias TakeHome.Crypto

  def encrypt(conn, _params) do
    encode = Map.new(conn.body_params, fn({key, value}) ->
      if is_binary(value) do
        {key,Crypto.encrypt(value)}
      else
        {key,Crypto.encrypt(Jason.encode!(value))}
      end
    end)
    conn|>put_status(200)|>json(encode)
  end

  def decrypt(conn,_params) do
    decode = Map.new(conn.body_params, fn({key,value}) ->
      {key,Crypto.decrypt(value)}
    end)
    conn|>put_status(200)|>json(decode)
  end

  def sign(conn,_params) do
    secretKey = "AAAA"
    hmac = Crypto.hmacSign(conn.body_params,secretKey)
    conn|>put_status(200)|>json(hmac)
  end

  def verify(conn,_params) do
    body = conn.body_params
    if Map.has_key?(body,"signature") && Map.has_key?(body,"data") do
      providedSign = body["signature"]

      secretKey = "AAAA"
      hmac = Crypto.hmacSign(body["data"],secretKey)

      if hmac === providedSign do

        IO.puts("test")
        # conn|>put_status(204)|> send_resp("", "")
        send_resp(conn,204,"")
      else
        conn|>put_status(400)|>json(%{message: "different #{hmac}"})
      end

    else
      conn|>put_status(400)|>json(%{message: "You need to provide the signature and the data"})
    end

  end
end
