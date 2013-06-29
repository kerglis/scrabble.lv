class Word

  attr_accessor :cells

  def initialize(cells = [])
    @cells = Cell.where(id: cells.map(&:id))
  end

  def to_s
    cells.map(&:to_s).join
  end

end