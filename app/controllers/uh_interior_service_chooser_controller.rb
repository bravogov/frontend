# Task-based service chooser. Read-only: no identity, status or case creation.
# Selection describes the responsible Interior Office route, not eligibility.
class UhInteriorServiceChooserController < ApplicationController
  layout "application"

  ROUTES = {
    "correct-citizenship" => { label: "Correct an existing citizenship record", service: "Request a correction to a United Hampshire Citizenship record", form_id: 3, category: :citizenship, advice: "Use this route for an error in a recorded citizenship status. A correction does not itself grant citizenship." },
    "prove-citizenship" => { label: "Get evidence of existing citizenship", service: "Request evidence of existing United Hampshire Citizenship", form_id: 4, category: :citizenship, advice: "This route checks an already established citizenship record. It is not a naturalisation application." },
    "naturalisation" => { label: "Apply for citizenship by naturalisation", service: "Apply for United Hampshire Citizenship by naturalisation", form_id: 9, category: :citizenship, advice: "The Immigration and Citizenship Service determines the applicable statutory requirements and evidence. Applying does not itself grant citizenship." },
    "register-child" => { label: "Register a child under 18 as a citizen", service: "Apply to register a person under 18 as a United Hampshire citizen", form_id: 10, category: :citizenship, advice: "The child registration procedure includes the relevant grounds, consent or parental responsibility, welfare and safeguarding checks." },
    "historical" => { label: "Request citizenship registration in a special or historical case", service: "Apply for citizenship registration in a special or historical case", form_id: 11, category: :citizenship, advice: "Historic participation and predecessor records may be evidence but do not automatically establish citizenship." },
    "resume" => { label: "Resume citizenship after renunciation", service: "Apply to resume United Hampshire Citizenship after renunciation", form_id: 12, category: :citizenship, advice: "The authority must check the original citizenship and renunciation records and the relevant conditions before deciding." },
    "visa" => { label: "Apply for a visa or entry permission", service: "Apply for immigration permission in Havenstead", form_id: 14, category: :immigration, advice: "United Hampshire Visas and Immigration carries out the assigned visa and immigration casework. Entry Advice from EACO is not a visa." },
    "residence" => { label: "Apply for residence or permission to remain in Havenstead", service: "Apply for immigration permission or residence", form_id: 14, category: :immigration, advice: "The Immigration Act 2026 and applicable Immigration Rules govern the particular permission; living in Havenstead and citizenship are different statuses." },
    "settlement" => { label: "Apply for settlement in Havenstead", service: "Apply for settlement in Havenstead", form_id: 14, category: :immigration, advice: "Settlement is a distinct immigration decision. It must be established in an authoritative status record and does not automatically confer citizenship." },
    "review-immigration" => { label: "Ask for an administrative review of an immigration decision", service: "Ask for an Administrative Review of an immigration decision", form_id: 16, category: :immigration, advice: "The review route depends on the decision and legal rights set out in the decision notice. Judicial or tribunal appeals are separate." },
    "status-evidence" => { label: "Get evidence of existing residence or immigration status", service: "Request evidence of immigration status", form_id: nil, category: :immigration, advice: "An existing decision and status record must be checked before evidence can be issued. This is not a fresh application to acquire status." },
    "british-nationality" => { label: "Ask about British nationality", service: "British nationality enquiry", form_id: nil, category: :citizenship, advice: "British nationality and United Hampshire Citizenship must not be assumed to be the same legal status. The assigned Interior Office function and applicable law must be established." }
  }.freeze

  def index
    @routes = ROUTES
    @selected = params[:service].to_s
    @error = params.key?(:service) && !ROUTES.key?(@selected)
    @route = ROUTES[@selected]
    response.status = :unprocessable_entity if @error
    response.headers["Cache-Control"] = "public, max-age=120"
  end
end
