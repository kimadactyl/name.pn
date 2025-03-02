class PronounSet < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }
  
  has_and_belongs_to_many :users

  def to_s(user=nil)
    if user&.pronoun_style_three?
      "#{nominative}/#{oblique}/#{possessive}"
    elsif nominative == oblique
      "#{nominative}/#{possessive}"
    else
      "#{nominative}/#{oblique}"
    end
  end
end
