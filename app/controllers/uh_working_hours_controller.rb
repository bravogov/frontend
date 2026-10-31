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
            @findings << (@weekly > 40 ? "The weekly figure exceeds the usual 40-hour UK limit for a young worker." : "The weekly figure does not exceed the usual 40-hour UK limit for a young worker.")
            @findings << (@longest > 8 ? "The longest shift exceeds the usual 8-hour daily limit for a young worker." : "The longest shift does not exceed the usual 8-hour daily limit for a young worker.")
            @findings << (@longest > 4.5 && @break_minutes < 30 ? "The break entered is shorter than the usual 30-minute break for a young worker working more than 4.5 hours." : "The break information does not show a breach of the ordinary young-worker minimum.")
          else
            @findings << (@weekly > 48 ? "The hours entered exceed 48 a week. For adults the UK limit is ordinarily assessed as an average over 17 weeks; one typical week alone cannot establish a breach." : "The hours entered do not exceed 48 in this week. UK adults are ordinarily assessed using an average over 17 weeks.")
            @findings << (@longest > 6 && @break_minutes < 20 ? "The break entered is shorter than the usual uninterrupted 20-minute rest break for a working day exceeding 6 hours." : "The break information does not show a breach of the ordinary adult minimum.")
          end
        else
          @findings << "You entered #{@weekly} hours per week and a longest shift of #{@longest} hours. These figures do not themselves establish compliance with United Hampshire public-service or voluntary-work requirements."
          @findings << "Check the relevant role terms and Department for Work and Skills arrangements. Acas supports in-scope public-service and voluntary-work disputes; HSE handles its assigned safety and regulatory functions."
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
