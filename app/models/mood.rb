class Mood < ApplicationRecord
  belongs_to :user, optional: true

  TASTES = %i[argentinian asian arazilian bbq burger chinese comfy coffee desserts french italian mexican peruvian pizza seafood sushi wine vegan]
  QUERY = ['romantic', 'good for groups', 'music', 'crowded']
end
