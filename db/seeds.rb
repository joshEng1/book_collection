# Fictional sample books make each environment easy to identify.
# Repeated releases preserve existing records and user edits.
samples = [
  [ "Lantern Bay", "A. Example", "12.50", "2020-01-15" ],
  [ "The Quiet Observatory", "B. Example", "18.00", "2021-03-12" ],
  [ "Paper Moons", "C. Example", "9.75", "2022-06-20" ],
  [ "A Map of Rain", "D. Example", "14.25", "2023-09-10" ],
  [ "The Last Orchard", "E. Example", "21.00", "2024-11-05" ]
]

samples.each do |title, author, price, published_date|
  seed_title = "#{Rails.env.titleize}: #{title}"
  Book.find_or_create_by!(title: seed_title) do |b|
    b.author = author
    b.price = price
    b.published_date = published_date
  end
end
