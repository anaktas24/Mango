# Clear existing data
UserBadge.destroy_all
UserStep.destroy_all
UserQuest.destroy_all
Badge.destroy_all
Step.destroy_all
QuestPrerequisite.destroy_all
Quest.destroy_all
User.destroy_all

# Test user
user = User.create!(
  email: "test@mango.com",
  password: "password123"
)

# Quests
permit = Quest.create!(
  title: "Get Your Residence Permit",
  description: "Register with your local municipality and obtain your B or L permit.",
  tips: "Bring original documents and a certified translation if needed.",
  external_url: "https://www.sem.admin.ch",
  estimated_duration: "1-2 weeks",
  xp_reward: 100,
  priority: 1,
  difficulty: :hard
)

banking = Quest.create!(
  title: "Open a Swiss Bank Account",
  description: "Set up a local bank account to receive your salary and pay bills.",
  tips: "UBS, PostFinance and Neon are popular options. Neon is easiest to open online.",
  estimated_duration: "1-3 days",
  xp_reward: 50,
  priority: 2,
  difficulty: :easy
)

housing = Quest.create!(
  title: "Find Housing",
  description: "Search for a flat and understand the Swiss rental process.",
  tips: "You will need a Betreibungsregisterauszug (debt collection extract) for most applications.",
  estimated_duration: "2-8 weeks",
  xp_reward: 150,
  priority: 3,
  difficulty: :hard
)

# Steps for permit quest
Step.create!(quest: permit, position: 1, title: "Gather documents", description: "Collect passport, employment contract, and passport photos.", xp_reward: 20)
Step.create!(quest: permit, position: 2, title: "Book appointment", description: "Book a slot at your Gemeinde (municipality office).", xp_reward: 10)
Step.create!(quest: permit, position: 3, title: "Attend appointment", description: "Attend in person and submit your documents.", xp_reward: 70)

# Steps for banking quest
Step.create!(quest: banking, position: 1, title: "Choose a bank", description: "Compare UBS, PostFinance, and Neon for your needs.", xp_reward: 10)
Step.create!(quest: banking, position: 2, title: "Open account online or in branch", description: "Complete identity verification (video call or in person).", xp_reward: 40)

# Steps for housing quest
Step.create!(quest: housing, position: 1, title: "Get debt collection extract", description: "Order a Betreibungsregisterauszug from your municipality.", xp_reward: 20)
Step.create!(quest: housing, position: 2, title: "Search listings", description: "Use Homegate, ImmoScout24 or Flatfox.", xp_reward: 10)
Step.create!(quest: housing, position: 3, title: "Submit applications", description: "Send your dossier including references and extract.", xp_reward: 50)
Step.create!(quest: housing, position: 4, title: "Sign rental contract", description: "Review and sign the Mietvertrag.", xp_reward: 70)

# Badges
Badge.create!(name: "First Step", description: "Completed your very first step.", icon: "star", trigger: "complete_first_step")
Badge.create!(name: "Quest Crusher", description: "Completed your first quest.", icon: "trophy", trigger: "complete_first_quest")
Badge.create!(name: "Swiss Ready", description: "Completed all core quests.", icon: "flag", trigger: "complete_all_quests")

puts "Seeded: #{Quest.count} quests, #{Step.count} steps, #{Badge.count} badges, #{User.count} user"
