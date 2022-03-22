class Mood < ApplicationRecord
  belongs_to :user, optional: true

  TASTES = %i[Argentinian Asian BBQ Brazilian Burger Comfy Chinese Coffee Desserts French Italian Mexican Peruvian Pizza Seafood Sushi Wine Vegan]
  QUERY = ['romantic', 'good for groups', 'music', 'crowded', 'family-friendly', 'fancy', 'good for dates', 'late night']
end
