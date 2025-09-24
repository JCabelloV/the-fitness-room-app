# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

felipe_cabello = User.create!(first_name: "Felipe", last_name: "Cabello", username: "satanas", email: "cabellovargasf@gmail.com", password_digest: "1234")
sher_roig = User.create!(first_name: "Sheryne", last_name: "Roig", username: "sherpersonaltrainer", email: "test@test.com", password_digest: "1234")
juan_cabello  = User.create!(first_name: "Juan", last_name: "Cabello", username: "wantan", email: "Cabellovargasj@gmail.com", password_digest: "4321")
