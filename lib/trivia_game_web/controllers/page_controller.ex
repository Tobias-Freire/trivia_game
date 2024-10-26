defmodule TriviaGameWeb.PageController do
  use TriviaGameWeb, :controller
  alias HTTPoison

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def config(conn, _params) do
    render(conn, "config.html")
  end

  def game(conn, %{"amount" => amount, "category" => category, "difficulty" => difficulty}) do
    # Construindo a url completa para requisição
    api_url =
      cond do
        category != 0 and difficulty != 0 ->
          "https://opentdb.com/api.php?amount=#{amount}&category=#{category}&difficulty=#{difficulty}&type=multiple"
        category != 0 ->
          "https://opentdb.com/api.php?amount=#{amount}&category=#{category}&type=multiple"
        difficulty != 0 ->
          "https://opentdb.com/api.php?amount=#{amount}&difficulty=#{difficulty}&type=multiple"
        true ->
          "https://opentdb.com/api.php?amount=#{amount}&type=multiple"
      end


    # Faz a requisição para a API
    case HTTPoison.get(api_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        trivia_data = Jason.decode!(body)
        render(conn, "game.html", trivia_data: trivia_data)
      {:error, %HTTPoison.Error{reason: reason}} ->
        text(conn, "Erro ao carregar perguntas: #{reason}")
    end
  end

end
