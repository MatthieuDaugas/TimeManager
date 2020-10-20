alias ApiTimeManager.Repo
alias ApiTimeManager.Users.User

Repo.insert! %User{
    name: "Jojo",
    description: "jojo@yopmail.com"
}
