puts "Clearing existing data..."
TimeAllocation.destroy_all
Location.destroy_all
User.destroy_all

puts "Creating user..."

created_user = User.create!({ name: "John Smith" })
puts "Created ID(#{created_user.id}): #{created_user.name}"

puts "Creating locations..."
locations = [
  { name: "Brazil" },
  { name: "Argentina" },
  { name: "Colombia" },
  { name: "United States" },
  { name: "Canada" },
  { name: "Portugal" },
  { name: "China" },
  { name: "South Africa" },
  { name: "Chile" },
  { name: "Mexico" }
]

created_locations = locations.map { |location| Location.create!(location) }

if created_locations.empty? || created_locations.any?(&:nil?)
  puts "Error: Failed to create locations properly"
  exit
end

puts "Creating time allocations..."
activities = ["Business Meeting", "Conference", "Training Workshop",
              "Site Visit", "Project Research", "Client Presentation",
              "Team Building", "Vacation", "Product Testing", "Strategic Planning"]

user_id = User.first.id
location_ids = Location.pluck(:id)

TimeAllocation.create!(
  user_id: user_id,
  location_id: location_ids.sample,
  activity: activities.sample,
  date: Date.new(2025, 1, 12)
)

TimeAllocation.create!(
  user_id: user_id,
  location_id: location_ids.sample,
  activity: activities.sample,
  date: Date.new(2025, 2, 8)
)

TimeAllocation.create!(
  user_id: user_id,
  location_id: location_ids.sample,
  activity: activities.sample,
  date: Date.new(2025, 3, 3)
)

TimeAllocation.create!(
  user_id: user_id,
  location_id: location_ids.sample,
  activity: activities.sample,
  date: Date.new(2025, 4, 22)
)

TimeAllocation.create!(
  user_id: user_id,
  location_id: location_ids.sample,
  activity: activities.sample,
  date: Date.new(2025, 5, 29)
)

TimeAllocation.create!(
  user_id: user_id,
  location_id: location_ids.sample,
  activity: activities.sample,
  date: Date.new(2025, 6, 2)
)

TimeAllocation.create!(
  user_id: user_id,
  location_id: location_ids.sample,
  activity: activities.sample,
  date: Date.new(2025, 7, 15)
)

TimeAllocation.create!(
  user_id: user_id,
  location_id: location_ids.sample,
  activity: activities.sample,
  date: Date.new(2025, 8, 19)
)

TimeAllocation.create!(
  user_id: user_id,
  location_id: location_ids.sample,
  activity: activities.sample,
  date: Date.new(2025, 8, 24)
)

TimeAllocation.create!(
  user_id: user_id,
  location_id: location_ids.sample,
  activity: activities.sample,
  date: Date.new(2025, 8, 27)
)

puts "Seed data created successfully!"
