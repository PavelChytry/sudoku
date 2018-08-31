SIZE = 9

class Point
  include Comparable
  attr_accessor :value, :options

  def initialize()
    @options = Array.new
    1.upto(SIZE) do |x|
      @options << x
    end
  end

  def dup
    res = self.class.new
    res.value = value
    res.options = options.dup
    res
  end

  def <=>(other)
    value <=> other
  end

  def options_count
    @options.length
  end

  def remove(val)
    @options.delete(val)
  end
  
  def to_s
    @value.to_s
  end
end

class Grid
  attr_accessor :data

  def initialize
    @data = Array.new(9) { Array.new(9){Point.new()} }
  end

  def [](idx)
    @data[idx]
  end

  def dup
    res = self.class.new
    0.upto(SIZE - 1) do |row|
      0.upto(SIZE - 1) do |col|
        res.data[row][col] = data[row][col].dup
      end
    end
    res
  end

  def load_data(data)
    0.upto(SIZE - 1) do |row|
      0.upto(SIZE - 1) do |col|
        value = data[row * 9 + col].to_i
        update(row, col, value)
      end
    end
  end

  def is_solved
    res = true
    data.each do |x|
      x.each do |y|
        if y.value == 0
          res = false
          break
        end
      end
    end
    res
  end

  def update(x, y, value)
    @data[x][y].value = value
    0.upto(SIZE - 1) do |i|
      @data[x][y].remove(i + 1) if value != 0
      @data[x][i].remove(value)
      @data[i][y].remove(value)
      a = (x / 3) * 3 + i.modulo(3)
      b = (y / 3) * 3 + (i / 3)
      @data[a][b].remove(value)
    end
  end

  def print
    puts "---------+---------+---------"
    data.each_with_index do |x, xi|
      str = ""
      x.each_with_index do |y, yi|
        if y.value > 0
          #str << " #{y.value} "
          str << " #{y.value}:#{y.options_count} "
        else
          #str << "   "
          str << " -:#{y.options_count} "
        end
        str << "|" if yi % 3 == 2 && yi < 8
      end
      puts str
      puts "---------+---------+---------" if xi % 3 == 2
    end
  end
end

class Solver
  attr_accessor :results, :to_solve, :x, :y

  def initialize(data)
    @results = Array.new
    @to_solve = Array.new
    g = Grid.new
    g.load_data(data)
    @to_solve << g
    @x, @y = 0, 0 
  end

  def get_result
    @res = ""
    tmp = @results.pop
    0.upto(8) do |i|
      0.upto(8) do |j|
       @res << tmp[i][j].to_s
      end
    end
    @res
  end

  def solve
    while to_solve.length != 0 
      tmp_grid = to_solve.pop
      while tmp_grid.is_solved != true 
        if find_next(tmp_grid)
          if tmp_grid[x][y].options_count == 1
            tmp_grid.update(x, y, tmp_grid[x][y].options.pop)
          else
            while tmp_grid[x][y].options_count > 1
              tmp_val = tmp_grid[x][y].options.pop
              new_grid = tmp_grid.dup
              new_grid.update(x, y, tmp_val)
              to_solve.push(new_grid)
            end
            tmp_grid.update(x, y, tmp_grid[x][y].options.pop)
          end
        else 
          break
        end
      end
      if tmp_grid.is_solved
        results.push(tmp_grid)
        break
      end
    end
  end

private
  def find_next(grid)
    found = false
    tmp_max = SIZE + 1
    0.upto(SIZE - 1) do |row|
      0.upto(SIZE - 1) do |col|
        if grid[row][col].value == 0 && grid[row][col].options_count > 0 && grid[row][col].options_count < tmp_max 
          @x, @y = row, col
          tmp_max = grid[row][col].options_count
          found = true
        end
      end
    end
    found
  end

end
