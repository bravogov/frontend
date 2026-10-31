require "date"
class UhClockChangesController < ApplicationController
  layout "application"

  def index
    @year = params[:year].present? ? Integer(params[:year], exception: false) : Date.today.year
    @invalid = @year.nil? || @year < 2025 || @year > 2040
    if @invalid
      @year = Date.today.year
      response.status = :unprocessable_entity
    end
    @dates = (@year..[@year+2,2040].min).map do |year|
      { year: year, forward: last_sunday(year,3), backward: last_sunday(year,10) }
    end
    response.headers["Cache-Control"]="public, max-age=300"
  end

  private

  def last_sunday(year,month)
    last=Date.new(year,month,-1)
    last - last.wday
  end
end
