defmodule AlexaDemo.Factory do
  use ExMachina.Ecto, repo: Authable.Repo
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  def client_factory do
    %Authable.Model.Client{
      name: Faker.Company.buzzword()
    }
  end

  def user_factory do
    password = "test1234" |> hashpwsalt()
    %Authable.Model.User{
      email: Faker.Internet.email(),
      password: password
    }
  end
end
