defmodule AlexaDemo.AlexaController do
  use AlexaDemo.Web, :controller
  use PhoenixAlexa.Controller, :create

  alias AlexaDemo.Alexa
  alias AlexaDemo.Alexa.Color

  def launch_request(conn, _request) do
    response = %Response{}
                |> set_output_speech(%TextOutputSpeech{text: "Welcome to primary colors. You can ask - what are the primary colors?"})

    conn |> set_response(response)
  end

  def intent_request(conn, "colors", _request) do
    text = "The primary colors are yellow, blue, and red."
    response = %Response{}
                |> set_output_speech(%TextOutputSpeech{text: text})
                |> set_should_end_session(true)

    conn |> set_response(response)
  end

  def intent_request(conn, "favorite", request) do
    {:ok, user} = current_user(conn)

    with {:ok, color} <- Alexa.create_favorite_color(user, favorite_color(request)) do
      response = %Response{}
                  |> set_output_speech(%TextOutputSpeech{text: "Your favorite color is now set to #{color.color}."})
                  |> set_should_end_session(true)
      conn |> set_response(response)
    end
  end

  def intent_request(conn, "myfavorite", request) do
    {:ok, user} = current_user(conn)
    with %Color{} = color <- Alexa.get_color_by_user(user) do
      response = %Response{}
                  |> set_output_speech(%TextOutputSpeech{text: "Your favorite color is set to #{color.color}."})
                  |> set_should_end_session(true)
      conn |> set_response(response)
    end
  end

  def intent_request(conn, "mix", request) do
    colors = [request.request.intent.slots["color_one"]["value"],
              request.request.intent.slots["color_two"]["value"]
             ] |> Enum.sort

    mixed_color = colors |> mix_colors

    text = "If you combine #{Enum.join(colors, " and ")}, you make the color #{mixed_color}"
    response = %Response{}
                |> set_output_speech(%TextOutputSpeech{text: text})
                |> set_should_end_session(true)

    conn |> set_response(response)
  end

  def intent_request(conn, "favorite_mix", request) do
    {:ok, user} = current_user(conn)
    color = Alexa.get_color_by_user(user).color

    mixing_color =  request.request.intent.slots["color"]["value"]

    mixing_colors = [mixing_color, color] |> Enum.sort

    mixed_color = mix_colors(mixing_colors)

    response = mixed_color_response(mixed_color, mixing_colors)

    conn |> set_response(response)
  end

  def mixed_color_response(nil, mixing_colors) do
    response = %Response{} |> set_output_speech(%TextOutputSpeech{text: "I don't know how to mix #{Enum.join(mixing_colors, " and ")}"})
  end

  def mixed_color_response(color, mixing_colors) do
    response = %Response{}
                |> set_output_speech(%TextOutputSpeech{text: "Mixing #{Enum.join(mixing_colors, " and ")} make the color #{color}."})
                |> set_should_end_session(true)
  end

  defp mixing_colors(request) do
    [color_from_slot(request.request.intent.slots["color_one"]), color_from_slot(request.request.intent.slots["color_two"])]
    |> Enum.sort
  end

  def color_from_slot(%{"value" => "read"}), do: "red"

  def color_from_slot(%{"value" => color}), do: color

  defp mix_colors(["blue", "red"]), do: "purple"

  defp mix_colors(["red", "yellow"]), do: "orange"

  defp mix_colors(["blue", "yellow"]), do: "green"

  defp mix_colors([color, color2]), do: "unknown"

  defp favorite_color(request), do: color_from_slot(request.request.intent.slots["color"])

  def session_end_request(conn, _request), do: conn

  defp current_user(conn) do
    token = conn.params["session"]["user"]["accessToken"]
    Authable.Authentication.Bearer.authenticate(%{"access_token" => token}, [])
  end
end
