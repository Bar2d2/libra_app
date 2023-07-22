Given('I go to the Homepage') do
  visit "/"
end

Then('I can see a welcome message') do
 expect(page).to have_content("Libra app")
end