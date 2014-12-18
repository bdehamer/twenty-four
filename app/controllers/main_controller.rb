class MainController < ApplicationController

  before_filter :validate, only: [:solve]

  def index; end

  def solve
    @answer_set = []
    ops = %w(+ + + - - - * * * / / /)
  
    num_sets = @terms.permutation.to_a.uniq
    op_sets = ops.combination(3).to_a.uniq

    num_sets.each do |num_set|
      op_sets.each do |op_set|
        op_set.permutation.to_a.uniq.each do |op_perm|

          a = num_set[0].to_f
          s = num_set[0].to_s
          op_perm.each_with_index do |op, i|
            a = a.send(op, num_set[i + 1]) 
            s += " #{op} #{num_set[i + 1]}"
          end 

          s += " = #{a.to_i}"
          @answer_set << s if a == 24.0
        end 
      end 
    end

    @answer_set << "No solutions for #{@terms.join(', ')}" if @answer_set.empty?
    render :index
  end

  private

  def validate
    terms = params[:terms].split()
    if terms.length != 4
      redirect_to "/", alert: 'not enough terms'
      return false
    end

    @terms = terms.map(&:to_i)
  end
end
