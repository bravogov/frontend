# Working-hours self-check. England figures use GOV.UK/Working Time Regulations.
# Havenstead's UH public-service context is NOT automatically UK employment law.
# Read-only: no applicant details or case records.
class UhWorkingHoursController < ApplicationController
  layout "application"

  def index
    @values = {
      "place" => params[:place].presence || "england",
      "age" => params[:age].presence || "adult",
      "weekly" => params[:weekly].to_s,
      "longest" => params[:longest].to_s,
      "break_minutes" => params[:break_minutes].to_s
    }
    @submitted = params.key?(:weekly)
    @error = nil
    @findings = []
    if @submitted
      unless %w[england havenstead].include?(@values["place"]) && %w[adult young].include?(@values["age"])
        @error = "Select a valid location and age group."
      end
      @weekly = parse(@values["weekly"],0,168)
      @longest = parse(@values["longest"],0,24)
      @break_minutes = parse(@values["break_minutes"],0,1440)
      @error ||= "Enter working hours and break lengths as valid non-negative numbers." if [@weekly,@longest,@break_minutes].any?(&:nil?)
      if @error.nil?
        if @values["place"] == "england"
          if @values["age"] == "young"
            @findings << (@weekly > 40 ? "The hours entered are above the usual 40-hour weekly limit for young workers in England." : "The hours entered are within the usual 40-hour weekly limit for young workers in England.")
            @findings << (@longest > 8 ? "The longest working day entered is above the usual 8-hour limit for young workers in England." : "The longest working day entered is within the usual 8-hour limit for young workers in England.")
            @findings << (@longest > 4.5 && @break_minutes < 30 ? "Young workers in England who work for more than 4.5 hours are normally entitled to a 30-minute rest break. The break entered is shorter than this." : "The break entered meets the usual young-worker minimum for the length of day entered.")
          else
            @findings << (@weekly > 48 ? "The hours entered are above 48 this week. The usual limit for adults in England is an average of 48 hours a week over 17 weeks, not a limit on every individual week." : "The hours entered are below 48 this week. The usual limit for adults in England is an average of 48 hours a week over 17 weeks.")
            @findings << (@longest > 6 && @break_minutes < 20 ? "Adults working for more than 6 hours in England are normally entitled to an uninterrupted 20-minute rest break. The break entered is shorter than this." : "The break entered meets the usual minimum for the length of working day entered.")
          end
        else
          @findings << "You entered #{@weekly} hours a week and a longest working day of #{@longest} hours. The terms of your Havenstead role determine which working-time arrangements apply."
          @findings << "Check your appointment or voluntary-work terms. If you need advice about an employment dispute, contact Acas. For a workplace health and safety concern, contact the Health and Safety Executive."
        end
      end
      response.status = :unprocessable_entity if @error
    end
    response.headers["Cache-Control"]="no-store"
  end

  private

  def parse(value,min,max)
    number=Float(value,exception:false)
    return nil unless number && number.finite? && number >= min && number <= max
    number
  end
end
