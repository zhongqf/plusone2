Template.explorerTeams.publicTeams = ->
  Teams.find({public: true})