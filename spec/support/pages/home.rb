class Home < SitePrism::Page
  set_url '/'

  def find_fullname(full_name)
    page.find(:xpath, "(//h1[contains(text(), '#{full_name}')])")
  end
end
