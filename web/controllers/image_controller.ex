defmodule Placex.ImageController do
  use Placex.Web, :controller

  @description_pattern ~r/(?<width>\d{1,4})x(?<height>\d{1,4})\.(?<format>png)/
  @color_pattern ~r/[0-9a-f]{6}/

  def index(conn, %{"description" => descriptor}) do
    description = parse_descriptor(descriptor)
    respond_for_decription(conn, description)
  end

  defp respond_for_decription(conn, nil) do
    conn |> send_resp(404, "")
  end

  defp respond_for_decription(conn, description) do
    conn |> respond_with_image(description)
  end

  defp parse_descriptor(descriptor) do
    lower = String.downcase(descriptor)
    case Regex.named_captures(@description_pattern, lower) do
      nil -> nil
      map -> normalize_description(map)
    end
  end

  defp normalize_description(%{"width" => ws, "height" => hs, "format" => fs}) do
    {w, ""} = Integer.parse(ws)
    {h, ""} = Integer.parse(hs)
    f       = String.to_atom(fs)
    %{width: w, height: h, format: f}
  end

  defp respond_with_image(conn, description) do
    conn
    |> put_image_content_type(description)
    |> send_resp(200, generate_image(description))
  end

  defp put_image_content_type(conn, %{format: f}) do
    type = Plug.MIME.type(Atom.to_string(f))
    conn
    |> put_resp_content_type(type)
  end

  defp generate_image(description) do
    Placex.ImageGenerator.render(description)
  end
end
