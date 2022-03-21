class Mood < ApplicationRecord
  belongs_to :user, optional: true

  TASTES = %i[Argentinian Asian Brazilian BBQ Burger Chinese Comfy Coffee Desserts French Italian Mexican Peruvian Pizza Seafood Sushi Wine Vegan]
  QUERY = ['romantic', 'good for groups', 'music', 'crowded']
end
