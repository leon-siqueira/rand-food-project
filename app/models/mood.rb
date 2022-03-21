class Mood < ApplicationRecord
  belongs_to :user, optional: true

  TASTES = %i[sushi pizza burger healthy]
  QUERY = ['romantic', 'good for groups', 'music', 'crowded']
end
