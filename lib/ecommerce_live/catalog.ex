defmodule EcommerceLive.Catalog do
  @moduledoc """
  The Catalog context handles all logic related to products and categories.
  """

  import Ecto.Query, warn: false
  alias EcommerceLive.Repo

  alias EcommerceLive.Catalog.{Category, Product}

  # ============================================================
  # CATEGORY FUNCTIONS
  # ============================================================

  @doc """
  Lists all categories, preloading their subcategories.
  """
  def list_categories do
    Repo.all(Category)
    |> Repo.preload(:subcategories)
  end

  @doc """
  Gets a single category by ID.
  Raises `Ecto.NoResultsError` if not found.
  """
  def get_category!(id) do
    Repo.get!(Category, id)
    |> Repo.preload([:parent, :subcategories])
  end

  @doc """
  Creates a new category using the provided attributes.
  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an existing category with the given attributes.
  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes the specified category.
  """
  def delete_category(%Category{} = category), do: Repo.delete(category)

  @doc """
  Returns a changeset for tracking category changes.
  Useful for forms and validations.
  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  @doc """
  Lists all root categories (i.e., categories with no parent).
  """
  def list_root_categories do
    from(c in Category, where: is_nil(c.parent_id))
    |> Repo.all()
  end

  @doc """
  Searches for categories by name or description.
  Performs a case-insensitive match.
  """
  def search_categories(term) do
    pattern = "%#{term}%"

    from(c in Category,
      where:
        ilike(c.name, ^pattern) or
        ilike(c.description, ^pattern),
      order_by: [asc: c.name]
    )
    |> Repo.all()
  end

  # ============================================================
  # PRODUCT FUNCTIONS
  # ============================================================

  @doc """
  Lists all products, preloading their associated categories.
  """
  def list_products do
    Repo.all(Product)
    |> Repo.preload(:category)
  end

  @doc """
  Gets a single product by ID.
  Raises `Ecto.NoResultsError` if not found.
  """
  def get_product!(id) do
    Repo.get!(Product, id)
    |> Repo.preload(:category)
  end

  @doc """
  Creates a new product using the provided attributes.
  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an existing product with new attributes.
  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes the specified product.
  """
  def delete_product(%Product{} = product), do: Repo.delete(product)

  @doc """
  Returns a changeset for tracking product changes.
  Useful for forms and validations.
  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  @doc """
  Lists all products belonging to a specific category.
  """
  def list_products_by_category(category_id) do
    from(p in Product, where: p.category_id == ^category_id)
    |> Repo.all()
    |> Repo.preload(:category)
  end

  @doc """
  Lists all active (visible) products.
  """
  def list_active_products do
    from(p in Product, where: p.is_active == true)
    |> Repo.all()
    |> Repo.preload(:category)
  end

  @doc """
  Searches for products by name or description.
  Performs a case-insensitive match.
  """
  def search_products(term) do
    pattern = "%#{term}%"

    from(p in Product,
      where:
        ilike(p.name, ^pattern) or
        ilike(p.description, ^pattern),
      preload: [:category]
    )
    |> Repo.all()
  end
end
