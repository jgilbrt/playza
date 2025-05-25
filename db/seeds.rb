puts "Deleting old data..."
Payment.delete_all
Award.delete_all
MatchPlayer.delete_all
Match.delete_all
User.delete_all
Team.delete_all
puts "Old data cleared ✅"

# Create team
puts "Creating team..."
team = Team.create!(
  name: "Brighton & Hove Albion",
  logo_url: "https://upload.wikimedia.org/wikipedia/en/thumb/f/fd/Brighton_%26_Hove_Albion_logo.svg/1200px-Brighton_%26_Hove_Albion_logo.svg.png"
)
puts "Team created ✅"

# Create manager
puts "Creating manager..."
manager = User.create!(
  email: "manager@playza.com",
  password: "password",
  role: "manager",
  team: team,
  first_name: "Graham",
  last_name: "Potter"
)
puts "Manager created ✅"

# Real-ish players for Brighton (2024/2025 season style)
player_data = [
  { first_name: "Lewis", last_name: "Dunk", email: "lewis.dunk@playza.com", role: "player" },
  { first_name: "Marc", last_name: "Cucurella", email: "marc.cucurella@playza.com", role: "player" },
  { first_name: "Pascal", last_name: "Gross", email: "pascal.gross@playza.com", role: "player" },
  { first_name: "Leandro", last_name: "Trossard", email: "leandro.trossard@playza.com", role: "player" },
  { first_name: "Robert", last_name: "Sanchez", email: "robert.sanchez@playza.com", role: "player" },
  { first_name: "Joël", last_name: "Veltman", email: "joel.veltman@playza.com", role: "player" },
  { first_name: "Moises", last_name: "Caicedo", email: "moises.caicedo@playza.com", role: "player" },
  { first_name: "Adam", last_name: "Lallana", email: "adam.lallana@playza.com", role: "player" },
  { first_name: "Danny", last_name: "Welbeck", email: "danny.welbeck@playza.com", role: "player" },
  { first_name: "Enock", last_name: "Mwepu", email: "enock.mwepu@playza.com", role: "player" },
  { first_name: "Alexis", last_name: "Mac Allister", email: "alexis.macallister@playza.com", role: "player" },
  { first_name: "Joel", last_name: "Veltman", email: "joel.veltman2@playza.com", role: "player" }, # intentional duplicate last name with diff email
  { first_name: "Jakub", last_name: "Moder", email: "jakub.moder@playza.com", role: "player" },
  { first_name: "Pascal", last_name: "Gross", email: "pascal.gross2@playza.com", role: "player" }, # duplicate intentional for seeding
  { first_name: "Marc", last_name: "Cucurella", email: "marc.cucurella2@playza.com", role: "player" }
]

puts "Creating players..."
players = player_data.map do |p|
  User.create!(
    email: p[:email],
    password: "password",
    role: p[:role],
    team: team,
    first_name: p[:first_name],
    last_name: p[:last_name]
  )
end
puts "Players created ✅"

# Create 15 matches (home & away against some real EPL teams)
opponents = [
  "Manchester United", "Chelsea", "Liverpool", "Arsenal", "Tottenham Hotspur",
  "Leicester City", "Newcastle United", "Everton", "West Ham United", "Aston Villa",
  "Wolves", "Crystal Palace", "Brighton Reserves", "Norwich City", "Brentford"
]

puts "Creating 15 matches..."
start_date = Date.new(Date.today.year - 1, 8, 10)
match_dates = (0..14).map { |i| start_date + (i * 14) } # every 2 weeks

matches = match_dates.each_with_index.map do |date, i|
  Match.create!(
    team: team,
    opponent_name: opponents[i],
    date: date,
    location: i.even? ? "Home" : "Away",
    score_own: rand(0..4),
    score_opponent: rand(0..4),
    season: date.year < Date.today.year ? "2023/2024" : "2024/2025",
    has_happened: date < Date.today
  )
end
puts "Matches created ✅"

# Create MatchPlayers with plausible stats
positions = ["goalkeeper", "defender", "midfielder", "striker"]
puts "Creating MatchPlayers with stats..."

matches.each do |match|
  players.each do |player|
    role = positions.sample
    goals = role == "striker" ? rand(0..3) : rand(0..1)
    assists = role == "midfielder" ? rand(0..2) : rand(0..1)
    MatchPlayer.create!(
      match: match,
      user: player,
      team: team,
      status: ["confirmed", "injured", "benched"].sample,
      role: role,
      goals_scored: goals,
      assists: assists
    )
  end
end
puts "MatchPlayers created ✅"

# Create 10 awards (Player of the Match and Dick of the Day)
puts "Creating awards..."
matches.sample(10).each do |match|
  potm_player = players.sample
  dotd_player = players.sample
  next if potm_player == dotd_player

  Award.create!(match: match, user: potm_player, award_type: "potm")
  Award.create!(match: match, user: dotd_player, award_type: "dotd")
end
puts "Awards created ✅"

# Create payments with a note about subs (paid/unpaid randomly)
puts "Creating payments..."
players.each do |player|
  Payment.create!(
    user: player,
    team: team,
    amount: 20.0,
    status: ["paid", "unpaid"].sample,
    note: "Monthly subs"
  )
end
puts "Payments created ✅"

puts "🎉 Realistic seeding complete!"
