# -*- coding: utf-8 -*-
class Supply < ActiveRecord::Base
  has_many :orders
  has_many :users, through: :orders

  def to_s
    name
  end

  def self.choices
    all.map { |supply| [supply.name, supply.id] }
  end

  def self.units
    ['mg', 'mL', 'g', 'dL', 'gr', 'kg', 'oz', 'tbsp', 'tsp', 'μg'].map { |u|
      [u,u] }
  end

  def self.lookup str
    where(['lower(shortcode) = ?', str.downcase]).first ||
    where(['lower(name) = ?',      str.downcase]).first ||
    raise("Unrecognized shortcode")
  end
end
