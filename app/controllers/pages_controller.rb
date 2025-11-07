class PagesController < ApplicationController
  def home; end

  def roulette_index
    # Vista de selección de ruletas
  end

  def roulette_all
    # Combinar todos los items: juegos, dinámicas y aplausos
    @items = []
    @items += Game.all.map { |g| { id: g.id, name: g.name, objective: g.objective, type: 'game' } }
    @items += Dynamic.all.map { |d| { id: d.id, name: d.name, objective: d.objective, type: 'dynamic' } }
    @items += Applause.all.map { |a| { id: a.id, name: a.name, objective: a.objective, type: 'applause' } }
  end
end
