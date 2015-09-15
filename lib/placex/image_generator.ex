defmodule Placex.ImageGenerator do
  @background_color "E0E0E0"
  @text_color "6D6D6D"
  @font Path.join([__DIR__, "..", "..", "priv", "Lato-Regular.ttf"])
  @resolution 72
  @sampling_factor 1

  def render(description) do
    case call_convert(description) do
      {data, 0} -> data
      _         -> nil
    end
  end

  defp call_convert(description) do
    System.cmd "convert", args_for_convert(description)
  end

  defp args_for_convert(%{width: w, height: h, format: f}) do
    [
      "-density", "#{@resolution * @sampling_factor}",         # sample up
      "-size", "#{w*@sampling_factor}x#{h*@sampling_factor}",  # corrected size
      "canvas:##{@background_color}",                          # background color
      "-fill", "##{@text_color}",                              # text color
      "-font", "#{@font}",                                     # font location
      "-pointsize", "25",                                      # font size
      "-gravity", "center",                                    # center text
      "-annotate", "+0+0", "#{w}x#{h}",                        # render text
      "-resample", "#{@resolution}",                           # sample down to reduce aliasing
      "#{f}:-"
    ]
  end
end
