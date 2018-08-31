class SudokusController < ApplicationController
  def index
    @sudokus = Sudoku.all
  end

  def show
    @sudoku = Sudoku.find(params[:id])
  end

  def new
    @sudoku = Sudoku.new
    dummy_data
  end
  
  def edit
   @sudoku = Sudoku.find(params[:id])
  end

  def create
    @sudoku = Sudoku.new
    load_data(params[:sudoku])
    if @sudoku.save
      redirect_to sudokus_path
    else
      render 'new'
    end
  end
  
  def update
    @sudoku = Sudoku.find(params[:id])
    load_data(params[:sudoku])
    if @sudoku.save
      redirect_to sudokus_path
    else
      render 'edit'
    end
  end

  def destroy
   @sudoku = Sudoku.find(params[:id])
   @sudoku.destroy
   redirect_to sudokus_path
  end

  def solve
    @sudoku = Sudoku.find(params[:format])
    @s = Solver.new(@sudoku.data)
    @s.solve
    @sudoku.data = @s.get_result
    @sudoku.save
    redirect_to @sudoku
  end

private
  def load_data(params)
    @sudoku.text = params[:text]
    @sudoku.data = ""
    0.upto(80) do |x|
      @sudoku.data << params["id_#{x}"]
    end
  end

  def dummy_data
    @sudoku.text = ""
    @sudoku.data = ""
    0.upto(80) do |x|
      @sudoku.data << "0"
    end
  end
end
