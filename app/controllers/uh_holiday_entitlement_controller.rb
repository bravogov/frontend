class UhHolidayEntitlementController < ApplicationController
  layout "application"

  def index
    @submitted = params.key?(:days)
    @days_input = params[:days].to_s
    @error = nil
    @entitlement = nil
    if @submitted
      days = Float(@days_input, exception: false)
      if !days || !days.finite? || days < 0.5 || days > 7 || (days * 2) % 1 != 0
        @error = "Enter the number of regular working days per week, from 0.5 to 7 in half-day increments."
        response.status = :unprocessable_entity
      else
        @entitlement = [(days * 5.6).round(2), 28].min
      end
    end
    response.headers["Cache-Control"] = "no-store"
  end
end
