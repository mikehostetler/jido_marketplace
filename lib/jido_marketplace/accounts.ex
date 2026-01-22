defmodule JidoMarketplace.Accounts do
  use Ash.Domain,
    otp_app: :jido_marketplace

  resources do
    resource JidoMarketplace.Accounts.Token
    resource JidoMarketplace.Accounts.User
  end
end
