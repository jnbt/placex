defmodule Placex.ImageGenerator do
  @background_color :egd.color({50, 50, 50})

  def render(%{width: w, height: h, format: f}) do
    img = :egd.create(w, h)
    :egd.filledRectangle(img, {0,0}, {w, h}, @background_color)
    :egd.render(img, f)
  end
end
