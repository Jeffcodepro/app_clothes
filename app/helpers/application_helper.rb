module ApplicationHelper
  def money_from_cents(cents)
    number_to_currency(
      cents.to_f / 100,
      unit: "R$ ",
      separator: ",",
      delimiter: "."
    )
  end

  def color_hex(color_name)
    normalized_color = color_name.to_s.downcase.strip

    colors = {
      "preto" => "#111111",
      "branco" => "#ffffff",
      "nude" => "#d8b7a3",
      "bege" => "#d8c3a5",
      "rosa" => "#e9a9bb",
      "rosa claro" => "#f4c7d4",
      "vermelho" => "#c92a2a",
      "vinho" => "#7b1e35",
      "azul" => "#2f5fbc",
      "azul marinho" => "#17233f",
      "cinza" => "#8f8f8f",
      "chumbo" => "#444444",
      "verde" => "#4f8f70",
      "lilás" => "#b79ad8",
      "roxo" => "#6f42c1",
      "marrom" => "#6f4e37"
    }

    colors[normalized_color] || "#d8d8d8"
  end

  def color_swatch_style(color_name)
    "background-color: #{color_hex(color_name)};"
  end

  def light_color?(color_name)
    color_hex(color_name).in?(["#ffffff", "#d8c3a5", "#d8b7a3", "#f4c7d4", "#d8d8d8"])
  end
end
