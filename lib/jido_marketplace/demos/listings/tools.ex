defmodule JidoMarketplace.Demos.Listings.Tools do
  @moduledoc """
  Wrapper tools for Listing actions with hardcoded actor context.

  These wrap the AshJido-generated actions and inject a default "user" actor
  so the ReActAgent can call them without needing to pass context.
  """

  alias JidoMarketplace.Demos.ListingsDomain
  alias JidoMarketplace.Demos.ListingsDomain.Listing

  # Hardcoded demo actor as a regular user (not admin)
  # This means the agent can only modify listings it created (seller_id matches)
  @default_actor %{id: "00000000-0000-0000-0000-000000000001", role: :user}

  def context do
    %{domain: ListingsDomain, actor: @default_actor}
  end

  defmodule CreateListing do
    use Jido.Action,
      name: "create_listing",
      description: "Create a new marketplace listing with title, price, and optional quantity",
      schema: [
        title: [type: :string, required: true, doc: "Title of the listing"],
        price: [type: :string, required: true, doc: "Price as decimal string (e.g. \"19.99\")"],
        quantity: [type: :integer, default: 1, doc: "Quantity available"]
      ]

    def run(params, _context) do
      Listing.Jido.Create.run(params, JidoMarketplace.Demos.Listings.Tools.context())
    end
  end

  defmodule ListListings do
    use Jido.Action,
      name: "list_listings",
      description: "List all marketplace listings",
      schema: [
        # Add an optional parameter to ensure proper JSON Schema generation
        # (empty schemas cause issues with some LLM APIs that require a 'type' field)
        verbose: [type: :boolean, default: false, doc: "Return detailed information (optional)"]
      ]

    def run(_params, _context) do
      case Listing.Jido.Read.run(%{}, JidoMarketplace.Demos.Listings.Tools.context()) do
        {:ok, listings} when is_list(listings) ->
          {:ok, %{count: length(listings), listings: listings}}

        {:ok, listing} ->
          {:ok, %{count: 1, listings: [listing]}}

        error ->
          error
      end
    end
  end

  defmodule UpdateListingPrice do
    use Jido.Action,
      name: "update_listing_price",
      description: "Update the price of a listing",
      schema: [
        id: [type: :string, required: true, doc: "ID of the listing to update"],
        price: [type: :string, required: true, doc: "New price as decimal string"]
      ]

    def run(params, _context) do
      Listing.Jido.UpdatePrice.run(params, JidoMarketplace.Demos.Listings.Tools.context())
    end
  end

  defmodule UpdateListingQuantity do
    use Jido.Action,
      name: "update_listing_quantity",
      description: "Update the quantity of a listing",
      schema: [
        id: [type: :string, required: true, doc: "ID of the listing to update"],
        quantity: [type: :integer, required: true, doc: "New quantity"]
      ]

    def run(params, _context) do
      Listing.Jido.UpdateQuantity.run(params, JidoMarketplace.Demos.Listings.Tools.context())
    end
  end

  defmodule PublishListing do
    use Jido.Action,
      name: "publish_listing",
      description: "Publish a draft listing to make it visible",
      schema: [
        id: [type: :string, required: true, doc: "ID of the listing to publish"]
      ]

    def run(params, _context) do
      Listing.Jido.Publish.run(params, JidoMarketplace.Demos.Listings.Tools.context())
    end
  end

  defmodule DeleteListing do
    use Jido.Action,
      name: "delete_listing",
      description: "Delete a listing",
      schema: [
        id: [type: :string, required: true, doc: "ID of the listing to delete"]
      ]

    def run(params, _context) do
      Listing.Jido.Destroy.run(params, JidoMarketplace.Demos.Listings.Tools.context())
    end
  end
end
