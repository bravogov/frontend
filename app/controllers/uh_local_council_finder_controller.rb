# Interactive GOV.UH local council finder. The dataset follows the recognised
# local areas and council commencement status in MICLG's operative machinery map.
# It is a selection lookup: it does not infer a boundary from a postcode.
class UhLocalCouncilFinderController < ApplicationController
  layout "application"

  AREAS = {
    "alderstead" => { name: "Alderstead", country: "Havenstead", region: "Steadfast", council: "Alderstead Council", operational: true, website: "https://alderstead.gov.uhrblx.com/" },
    "brightmere" => { name: "Brightmere", country: "Havenstead", region: "Steadfast", council: "Brightmere Council", operational: true, website: "https://brightmere.gov.uhrblx.com/" },
    "stonehaven" => { name: "Stonehaven", country: "Havenstead", region: "Steadfast", council: "Stonehaven Council", operational: true, website: "https://stonehaven.gov.uhrblx.com/" },
    "rosehaven" => { name: "Rosehaven", country: "Havenstead", region: "Hearth", council: "Rosehaven Council", operational: false, website: nil },
    "bridgewell" => { name: "Bridgewell", country: "Havenstead", region: "Hearth", council: "Bridgewell Council", operational: false, website: nil },
    "greenhaven" => { name: "Greenhaven", country: "Havenstead", region: "Hearth", council: "Greenhaven Council", operational: false, website: nil }
  }.freeze

  SERVICES = {
    "general" => "General local council services",
    "libraries" => "Libraries and local archives",
    "community" => "Neighbourhood and community services",
    "recreation" => "Local recreation and community activities",
    "planning" => "Local place planning and neighbourhood matters",
    "elections" => "Local elections and electoral services"
  }.freeze

  def index
    @areas = AREAS
    @services = SERVICES
    @selected_area = params[:area].to_s
    @selected_service = params[:service].presence || "general"
    @error = flash.now[:finder_error] if params[:error].present?
    response.headers["Cache-Control"] = "public, max-age=60"
  end

  def result
    @area = AREAS[params[:area].to_s]
    @service = SERVICES[params[:service].to_s]
    if @area.nil? || @service.nil?
      @areas = AREAS
      @services = SERVICES
      @selected_area = params[:area].to_s
      @selected_service = params[:service].presence || "general"
      @error = "Select a recognised local area and a service."
      render :index, status: :unprocessable_entity
      return
    end
    response.headers["Cache-Control"] = "public, max-age=60"
  end
end
