# Clear existing data (optional)
Payment.delete_all
Award.delete_all
MatchPlayer.delete_all
Match.delete_all
User.delete_all
Team.delete_all

# Create a Team
team = Team.create!(name: "Wessex Warriors", logo_url: "https://example.com/logo.png")

# Create Manager
manager = User.create!(
  email: "manager@playza.com",
  password: "password",
  role: "manager",
  team: team
)

# Create 10 Players
players = []
10.times do |i|
  players << User.create!(
    email: "player#{i+1}@playza.com",
    password: "password",
    role: "player",
    team: team
  )
end

# Create 10 Matches (some in past, some future), assign seasons alternating
10.times do |i|
  Match.create!(
    team: team,
    opponent_name: "Opponent #{i+1}",
    date: (i.even? ? i.days.from_now : i.days.ago),
    location: i.even? ? "Home" : "Away",
    score_own: nil,
    score_opponent: nil,
    season: i < 5 ? "2023/2024" : "2024/2025"
  )
end

matches = Match.all.to_a

# Link 10 players to each match with MatchPlayer
matches.each do |match|
  players.each_with_index do |player, index|
    MatchPlayer.create!(
      match: match,
      user: player,
      status: ["confirmed", "pending", "declined"].sample,
      role: ["goalkeeper", "defender", "midfielder", "striker"].sample,
      goals_scored: rand(0..3),
      assists: rand(0..3)
    )
  end
end

# Add some Awards randomly for matches and players
matches.sample(5).each do |match|
  winners = players.sample(2)
  Award.create!(match: match, user: winners[0], award_type: "potm") # Player of the match
  Award.create!(match: match, user: winners[1], award_type: "dotd") # Dick of the day
end

# Create payments for players (some paid, some unpaid)
players.each do |player|
  Payment.create!(user: player, amount: 15.0, status: ["paid", "unpaid"].sample, note: "Monthly subs")
end
