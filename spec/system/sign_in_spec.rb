RSpec.describe "Sign in" do
  describe "Sign-in help page" do
    before do
      payload = {
        base_path: "/sign-in",
        format: "special_route",
        title: "Sign in to a service",
        description: "",
        details: {
          body: "",
        },
      }
      stub_content_store_has_item("/sign-in", payload)
    end

    it "renders the sign-in help page correctly" do
      visit "/sign-in"

      expect(page).to have_title("Sign in to a service")

      expect(page).to have_text("Search GOV.UH for a service")
      expect(page).to have_button("Search")
    end

    it "includes search facets as hidden elements" do
      visit "/sign-in"

      expect(page).to have_field("content_purpose_supergroup[]", type: :hidden, with: "services")
    end

    it "explains how to find UH service accounts" do
      visit "/sign-in"

      expect(page).to have_text("Find services and account guidance")
    end

    it "links to actual UH service discovery rather than UK accounts" do
      visit "/sign-in"

      expect(page).to have_link("Search GOV.UH services and information", href: "/search/all")
      expect(page).to have_link("Departments and public bodies", href: "/government/organisations")
      expect(page).to have_no_link("HMRC services")
      expect(page).to have_no_link("Get the GOV.UK app")
    end
  end
end
