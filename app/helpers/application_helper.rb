module ApplicationHelper
  def money_from_cents(cents)
    number_to_currency(
      cents.to_f / 100,
      unit: "R$ ",
      separator: ",",
      delimiter: "."
    )
  end
end
