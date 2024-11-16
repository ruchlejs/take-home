defmodule TakeHomeWeb.CryptController do
  use TakeHomeWeb, :controller
  def encrypt(conn, _params) do
    json(conn,%{message: "encypt"})
  end

  def decrypt(conn,_params) do
    json(conn,%{message: "decrypt"})
  end

  def sign(conn,_params) do
    json(conn,%{message: "sign"})
  end

  def verify(conn,_params) do
    json(conn,%{message: "verify"})
  end
end
