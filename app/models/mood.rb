class Mood < ApplicationRecord
  belongs_to :user, optional: true
end
