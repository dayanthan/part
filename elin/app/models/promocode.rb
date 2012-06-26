class Promocode < ActiveRecord::Base
#	attributes: name, valid
attr_accessible :name, :valid, :price
validates_presence_of :name
validates_presence_of :price
validates_numericality_of :price
end
