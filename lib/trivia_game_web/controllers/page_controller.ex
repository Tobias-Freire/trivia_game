defmodule TriviaGameWeb.PageController do
  use TriviaGameWeb, :controller
  alias HTTPoison

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def play(conn, _params) do
    render(conn, "play.html")
  end

  def continue(conn, %{"amount" => amount, "category" => category, "difficulty" => difficulty}) do
    # Construa a URL da API do Open Trivia Database
    api_url = "https://opentdb.com/api.php?amount=#{amount}&category=#{category}&difficulty=#{difficulty}&type=multiple"

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
