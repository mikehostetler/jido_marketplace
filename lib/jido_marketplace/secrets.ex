defmodule JidoMarketplace.Secrets do
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        JidoMarketplace.Accounts.User,
        _opts,
        _context
      ) do
    Application.fetch_env(:jido_marketplace, :token_signing_secret)
  end
end
