defmodule Todos.Todo do
  use Todos.Web, :model
  alias Todos.Todo
  alias Todos.Repo

  schema "todos" do
    field :name, :string

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  defmacrop levenshtein(lhs, rhs) do
    quote do
      fragment("levenshtein(?, ?)", unquote(lhs), unquote(rhs))
    end
  end

  def fuzzy_name_search(query \\ Todo, query_string) do
    from q in query,
      where: levenshtein(q.name, ^query_string) < 5,
      order_by: levenshtein(q.name, ^query_string),
      limit: 10
  end
end
