class Player < ApplicationRecord
    include Hashid::Rails
    has_many :withdraws
    has_many :chests
end
