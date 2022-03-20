class Mood < ApplicationRecord
  belongs_to :user, optional: true

  TASTES = %i[sushi pizza burger healthy]
  # QUERY = %i[music romantic crowded]
end
