defmodule AlexaDemo.Alexa.Response do
  import PhoenixAlexa.{Controller, Response}
  alias PhoenixAlexa.{Response, TextOutputSpeech, SimpleCard}
  @moduledoc """
  The boundary for the Alexa system.
  """

  def generate_response(opts) do
    session = Map.get(opts, :session, %{})
    card = %SimpleCard{}
          |> set_title(opts.title)
          |> set_content(opts.content)

    %Response{}
    |> set_output_speech(%TextOutputSpeech{text: opts.content})
    |> set_card(card)
    |> set_session_attributes(session)
    |> set_should_end_session(opts.terminate_session)
  end
end
